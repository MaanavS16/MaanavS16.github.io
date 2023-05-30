---
layout: single
title:  "Effects of Cache on Application Performance"
date:   2023-05-23 15:23:54 -0400
categories: systems embedded
---

Memory access times play a huge role on performance characteristics of programs. Here I conduct a set of experiments to isolate and understand these effects.


## Introduction
Memory is absolutely essential in the field of computing. From an automata theory standpoint, it's the key tool that enables us to reason with context-free and recursively enumerable languages. Beyond the theoretical power memory yields, the behavior of various memory models and techniques heavily influence modern software.

My goal with these experiments is to fill in some of the holes in my knowledge with some hands on analysis and some documentation I can reference in the future. Before diving into the details I'd like to do a bottom-up review of computer memory in general. 

## Types of Memory
The basic concept of memory in computer is to create a physical representation for data that can be written to and read from.

| Type        | Access Latency | Notes |
| ----------- | ----------- |
| Static Random Access Memory (SRAM)  | **1-10 ns** | Super fast and super expensive. Built with transistors + pretty much a [D-Latch](https://www.build-electronic-circuits.com/d-latch/) |
| Dynamic Random Access Memory (DRAM) | **~50 ns**  | Main memory implemented with this. Fast and expensive |
| Flash Memory | **1-100 µs** | No moving components and still non-volatile |
| Disk Storage | **~10 ms** w/ 7200 rpm | Cheap spinning disks with magnetic platters and a read/write head that sets and specific magnetized regions. |
| Magnetic Tape | **seconds to hours** | Used for archival storage. Extremely high capacity per unit cost. Cool [example](https://archiveprogram.github.com/arctic-vault/) |

{: .notice}
Note: All of these access times are mostly for determining a general order of magnitude. At small-time scales the distance between the processor and the memory cells can play a significant role in access latency.

![memory hierarchy](/assets/images/MemoryHierarchy.png)

The above figure demonstrates the scarcity, speed, and cost of the memory types. Where the top of the pyramid has the least quantity, highest cost, and highest speed.


## Cache Layout:

The Von Neumann architecture prescribes a unified memory store that both contains instructions and application data. While this is mostly true, as the system memory is unified, there exists a lower latency intermediate memory within the CPU that contains a portion of the memory space. The CPU can often avoid making costly accesses to the 

A cache essentially acts as a lower latency intermediary between the CPU and system memory (or even another slower cache). It saves data entries that are likely to be accessed in the future and makes them available for quick access. When a particular memory addresses is trying to resolved, the cache is first checked and can potentially massively decrease access latency.

This cache differs from the main memory in more ways than just speed however. The cache is designed to determine what's "likely to be accessed in the future". The strategy for completing this determination varies between caches and depends on the access patterns and configuration. 

 
### Should instructions and data be cached separately?


| Decision | Pros | Cons |
| ----------- | ----------- | ----------- |
| Yes | More hits per cache = more hits overall | If predecessor cache's use a separate store, then then the access patterns will make this less cache effective. |
| No  | Simple and fast | Cache trashing can occur: lines are being wasted by flip-flopping between instructions and data |

Due to the advantages of separately caching instructions and data, most modern processors have separate caches at the first level. However, subsequent layers are unified due to the diminishing performance returns with further separation on larger caches. The following diagram diagrams the cache in my current CPU. Notably, there are 3 stages to the cache.

* L1i: Per core instruction cache + L1d: Per core data cache
* L2: Per core unified cache following L1
* L3: Across core unified cache

![cpu diagram](/assets/images/cpu_diagram.png)

Now that we've covered the high level design of a cpu cache scheme, let's focus on the specific design of each of the cache boxes in the diagram. There are 2 main types of cache strategies: Direct map and Set associative.

### Direct mapped or set associative?
#### Direct mapped:

Partition the memory space into n regions, where there are n lines in the cache (So each partition gets a single line in the physical cache). If n is a power of two, then you can use the upper-order bits of an address to identify what the corresponding cache line is.

Each cache contains multiple words, meaning a single memory access

Steps for memory lookup in a direct mapped cache:

1. CPU executes load instruction for a particular address.
2. Set index portion of the address determines the relevant cache line
3. (a) if the valid flag is set and the tag matches then the cache has hit. Return correct word by finding the offset within the data-field.
3. (b) otherwise, issue a memory fetch from upper level cache/memory. After that's resolved, evict the data and update the data field, tag, and set the valid bit.


![dmcache](/assets/images/Block-diagram-of-a-direct-mapped-cache.png)

#### Set Associative:

A set associative cache is similar to a stack of smaller direct mapped caches. That's to say, each partition of the memory space has k corresponding caches lines across the k stacked direct mapped caches. This type of cache is called a k-way set associative cache.

Now that there are more than one cache lines for a particular set, more logic needs to be implemented for deciding which entires from the set get to stay and which get evicted from the cache. In order to implement this behavior, there are a few bits in the cache line to store information about that particular entry.

These bits are often used to store either frequency or access time information. With that the eviction strategy can be to remove the least frequently accessed data region or the last accessed data region. (LFU/LRU caches)

Steps for memory lookup in a direct mapped cache:

1. CPU executes load instruction for a particular address.
2. Set index portion of the address determines the relevant cache lines
3. (a) If the valid flag is set and the tag matches in any of the cache lines, return correct word by finding the offset within the data-field. Update the frequency or access time bits if applicable
3. (b) otherwise, issue a memory fetch from upper level cache/memory. After, determine which line should be evicted to make space if any.

![sacache](/assets/images/sacache.jpg)

A set associative cache is more advanced than a direct map cache, which results in more intelligent cache eviction and consequently higher hit rates. However, this comes at the cost of complexity and it's associated latency increases.

average_latency = hit% * (cache access latency) + (1-hit%) * (memory access latency)

Where, hit% is determined by the cache type, strategy, and access patterns
and cache access latency is determined by the design and complexity of the cache




## Jumping into some code

After the introduction to basic cache structures, I've set 2 tasks for myself.

1. Explore, the effect of caches on C++ STL data structures
2. Determine the cache layout for my processor

{% capture notice-2 %}
All following benchmarks will be run w/
- i9-10980XE processor
- 2x32 GB DDR4 Memory @ 2666 MHZ
- gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)
- [google benchmarking library](https://github.com/google/benchmark)
{% endcapture %}

<div class="notice">{{ notice-2 | markdownify }}</div>

### C++ STL Containers

The primary place I want to look at the performance impacts of CPU caching is within the space of C++ Data Structures. In a traditional DSA class, performance considerations for an algorithm are solely based on the asymptotic runtime behavior. This is shown to be a very simplistic model and doesn't convey much information about the runtime characteristics related to the host architecture.

In my tests, I will measure the lookup time for a particular integer key value pair across `std::vector<std::pair<int, int>>`, `std::map<int, int>`, `std::unordered_map<int, int>`. Each of these collections will be initialized with ascending keys and a matching 32 bit integer (8 bytes per element).

#### Optimal Setup

Initially, I want to gauge the lookup time for an ideal situation (ie where the cache is maximally effective). This means that the same element will be queried repeatedly so that the cache is always "hot". Furthermore, the data structures will be initialized in a way that avoid dynamic reallocation and collisions, typically with the `reserve` routine prior to benchmarking.

First, I will define a benchmarking fixture which defines the collection and prevents repeated initialization of the containers (benchmarking is very slow without this). The below code is the Bench setup for the `std::unordered_map`.

{% highlight c++%}
class UnorderedMapFixture : public benchmark::Fixture {
public:
  void SetUp(const ::benchmark::State& state) {
    // preallocate space for n elements: controls the load factor of the map
    map.reserve(state.range(0));

    // populate the unordered_map
    for (int i = 0; i < state.range(0); ++i)
      map[i] = i;
  }

  void TearDown(const ::benchmark::State& /*state*/) {
    // Clear the unordered_map
    map.clear();
  }
  std::unordered_map<int, int> map;
};
{% endhighlight %}

***

Ok now that the underlying container has been initialized, a simple routine is written to poll the same arbitrary number from the container. This is automatically timed by the benchmark library for size over the interval [8, 8 * 2^24].

{% highlight c++%}
BENCHMARK_DEFINE_F(UnorderedMapFixture, BM_UnorderedMapLookup)(benchmark::State& state) {
  
  // use n/2 to poll
  int key = state.range(0) / 2;

  for (auto _ : state) {
    auto it = map.find(key);
    if (it != map.end()) {
      int value = it->second;
      benchmark::DoNotOptimize(value);
    }
  }
}
// Register the lookup benchmark with the fixture
BENCHMARK_REGISTER_F(UnorderedMapFixture, BM_UnorderedMapLookup)->Range(8, 8 << 24);
BENCHMARK_MAIN();
{% endhighlight %}

{: .notice}
Note: `benchmark::DoNotOptimize` is used to indicate to the compiler that it should not optimize away the lookup despite the value not being used.

While executing this program, the benchmarking utility will determine the number of iterations required to build a high confidence estimate for the true average runtime. The timing results for each unordered_set size, including iterations, is shown in the console output snippet below.

```
Running ./benchmark
Run on (36 X 3000 MHz CPU s)
CPU Caches:
  L1 Data 32 KiB (x18)
  L1 Instruction 32 KiB (x18)
  L2 Unified 1024 KiB (x18)
  L3 Unified 25344 KiB (x1)
Load Average: 0.00, 0.08, 0.09
----------------------------------------------------------------------------------------------
Benchmark                                                    Time             CPU   Iterations
----------------------------------------------------------------------------------------------
UnorderedMapFixture/BM_UnorderedMapLookup/8               81.6 ns         81.6 ns      8589041
UnorderedMapFixture/BM_UnorderedMapLookup/64              81.6 ns         81.6 ns      8580608
UnorderedMapFixture/BM_UnorderedMapLookup/512             85.2 ns         85.2 ns      8590001
UnorderedMapFixture/BM_UnorderedMapLookup/4096            87.6 ns         87.6 ns      8000064
UnorderedMapFixture/BM_UnorderedMapLookup/32768           87.6 ns         87.6 ns      7997139
UnorderedMapFixture/BM_UnorderedMapLookup/262144          87.6 ns         87.6 ns      7874893
UnorderedMapFixture/BM_UnorderedMapLookup/2097152         81.6 ns         81.6 ns      8252177
UnorderedMapFixture/BM_UnorderedMapLookup/16777216        87.6 ns         87.6 ns      7988971
UnorderedMapFixture/BM_UnorderedMapLookup/134217728       88.0 ns         88.0 ns      7996966
```

This procedure was repeated for all of the containers, and the plots are shown below:

![optimal plots](/assets/images/cache_bms/optimal.png)


These results look great! This behavior almost perfectly models the asympototic behavior of the functions:
* The unordered map has a constant runtime: It takes ~85ns to lookup an element at both 8 elements and 100 million elements
* The map has a log runtime. This manifests as a linear plot when the x-axis is log scaled.
* The map has a log runtime. This manifests as an exponential plot when the x-axis is log scaled.


***
#### Realistic setup

Ok, so establishing the data structures to always make effective use of the cache clearly provides consistently excellent performance and highlights the effect of algorithmic complexity on the runtime. This occurs due to repeatedly accessing the same few memory regions: taking advantage of the principle of [temporal locality](https://www.sciencedirect.com/topics/computer-science/temporal-locality#:~:text=Temporal%20locality%20is%20the%20tendency,an%20appropriate%20data%2Dmanagement%20heuristic.).

In order to create a more realistic situation with significantly more cache misses, the element to lookup will be randomly generated from a uniform distribution. This means the probability of a cache hit is approx:

![hit eq](/assets/images/cache_bms/eq1.png)

This situation is likely bordering artificially inefficient, since it's rare for memory accesses to be completely random, but it should still illustrate what happens when the size of the collection exceeds the bounds of a cache.