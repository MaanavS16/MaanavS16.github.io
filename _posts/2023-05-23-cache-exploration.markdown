---
layout: single
title:  "Effects of Cache on Application Performance"
date:   2023-05-23 15:23:54 -0400
categories: systems embedded
---

Memory access times play a huge role on performance characteristics of programs. Here I conduct a set of experiments to isolate and understand these effects.


## tl;dr
Memory is absolutely essential in the field of computing. From an automata theory standpoint, it's the key tool that enables us to reason with context-free and recursively enumerable languages. Beyond the theoretical power memory yields, the behavior of various memory models and techniques heavily influence modern software.

My goal with these experiments is to fill in some of the holes in my knowledge with some hands on analysis with some documentation I can reference in the future. Before diving into the details I'd like to do a bottom-up review of computer memory in general. 

## Types of Memory
The basic concept of memory in computer is to create a physical representation for data that can be written to and read from.

1. SRAM: Static Random Access Memory
    - **1-10 ns** access times
    - Built with transistors: Pretty much a D-Latch
    - This is how register files in the CPU work
    - Super expensive
2. DRAM: Dynamic Random Access Memory
    - **~50 ns** access times
    - Main memory implemented with this
    - Less super expensive
3. Flash memory:
    - **1-100 µs** access times
    - No moving components while also being 
    - Cheap
4. Disk Storage
    - 7200 rpm (most common speed) has **~10ms access time**
    - Spinning disks with magnetic platters and a read/write head that sets and specific magnetized regions.
    - Very cheap
5. Magnetic Tape
    - You as a person need to retrieve the tapes :3
    - Used for long term archival of data
    - Github put a lot of these with open source code near the [north pole](https://archiveprogram.github.com/arctic-vault/)


![memory hierarchy](/assets/images/MemoryHierarchy.png)
Note: All of these access times are mostly for determining the OOM. Since at small-time scales the distance between the processor and the memory cells can play a significant role in access latency.

The above figure is present in every Comp Org textbook and if you're not familiar shows amount, cost, and speed of various memory nodes. Where the top of the pyramid has the least quantity, highest cost, and highest speed.


## Cache Layout:

The classic Von Neumann architecture, prescribes a unified memory store that both contains instructions and application data. While this is mostly true if you focus on the main system memory there a sequence of faster SRAM based hardware memory component called known as the CPU Cache.

A cache essentially acts as a lower latency intermediary between the CPU and system memory. It saves data entries that are likely to be accessed in the future and makes them available for quick access. When a particular memory addresses is trying to resolved, the cache is first checked.

This cache differs from the main memory in more ways than just speed however. The cache needs to determine what's "likely to be accessed in the future"

This process is determined by a few design choices:
1. Should instructions and data be cached separately?
    - Pros for yes: Different access patterns for data and instructions 
    - Pros for no: Simpler and less hardware required: Translates to speed
2. Direct mapped or set associative?

#### Direct mapped:

Partition the memory space into n regions, where there are n lines in the cache (So each partition gets a single line in the physical cache). If n is a power of two, then you can use the upper-order bits of an address to identify what the corresponding cache line is.

Each cache contains multiple words, meaning a single memory access

Steps for memory lookup in a direct mapped cache:

1. CPU executes load / store instruction for a particular address.
2. Set index portion of the address determines the relevant cache line
3. (a) if the valid flag is set and the tag matches then the cache has hit. Return correct word by finding the offset within the data-field.
3. (b) otherwise, issue a memory fetch from upper level cache/memory. After that's resolved, evict the data and update the data field, tag, and set the valid bit.

![dmcache](/assets/images/Block-diagram-of-a-direct-mapped-cache.png)

#### Set Associative:

A set associative cache is similar to a stack of smaller direct mapped caches. That's to say, each partition of the memory space has k corresponding caches lines across the k stacked direct mapped caches. This type of cache is called a k-way set associative cache.

Now that there are more than one cache lines for a particular set, more logic needs to be implemented for deciding which entires from the set get to stay and which get evicted from the cache. In order to implement this behavior, there are a few bits in the cache line to store information about that particular entry.

These bits are often used to store either frequency or access time information. With that the eviction strategy can be to remove the least frequently accessed data region or the last accessed data region. (LFU/LRU caches)

Steps for memory lookup in a direct mapped cache:

1. CPU executes load / store instruction for a particular address.
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


> All following benchmarks will be run on a i9-10980XE processor
>
> 2x32 GB DDR4 Memory @ 2666 MHZ
>
> gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)
>
> [google benchmarking library](https://github.com/google/benchmark)

### C++ STL Containers

The first place I want to look at the performance impacts of CPU caching is within the space of C++ Data Structures. In a traditional DSA class, performance considerations for an algorithm are solely based on the asymptotic runtime behavior. This is shown to be a very simplistic model and doesn't convey much information about the runtime characteristics related to the host architecture.

In my tests, I will measure the lookup time for a particular integer key value pair across a `std::vector<pair<int, int>>`, `std::map<int, int>`, `std::unordered_map<int, int>`. Each of the collections will be populated with n ascending integers. For testing, a single randomly generated element will be queried and a lookup will be executed: The benchmarking utility will repeat this operating many times to acquire a statistically significant estimate for the true runtime. This means there will be a guaranteed hit in the container, but at an arbitrary point to give a good estimate for average runtime.



{% highlight c++ %}
#include <unordered_map>
#include <map>
#include <vector>
#include <random>
#include <algorithm>
#include <benchmark/benchmark.h>

const int r = 23;
// Function to generate a random integer within a range
int generateRandomInt(std::mt19937& gen, int min, int max) {
    std::uniform_int_distribution<int> distribution(min, max);
    return distribution(gen);
}
{% endhighlight %}
{% highlight c++ %}
// Benchmark function to measure the lookup time for a random element in an unordered_map
static void BM_UnorderedMapLookup(benchmark::State& state) {
    // Generate an unordered_map of the specified size
    std::unordered_map<int, int> myMap;
    const int mapSize = state.range(0);
    for (int i = 0; i < mapSize; ++i) {
        myMap[i] = i;
    }

    // Random number generator
    std::random_device rd;
    std::mt19937 gen(rd());

    // Perform lookup benchmarks
    for (auto _ : state) {
        // Generate a random key within the range of the map
        int randomKey = generateRandomInt(gen, 0, mapSize - 1);
        
        // Perform the lookup
        auto it = myMap.find(randomKey);
        if (it != myMap.end()) {
            benchmark::DoNotOptimize(it->second);  // Prevent the compiler from optimizing the lookup away
        }
    }
}
BENCHMARK(BM_UnorderedMapLookup)->Range(8, 8 << r);  // Vary the map size from 8 to 8192
{% endhighlight %}
{% highlight c++ %}
// Benchmark function to measure the lookup time for a random element in a map
static void BM_MapLookup(benchmark::State& state) {
    // Generate a map of the specified size
    std::map<int, int> myMap;
    const int mapSize = state.range(0);
    for (int i = 0; i < mapSize; ++i) {
        myMap[i] = i;
    }

    // Random number generator
    std::random_device rd;
    std::mt19937 gen(rd());

    // Perform lookup benchmarks
    for (auto _ : state) {
        // Generate a random key within the range of the map
        int randomKey = generateRandomInt(gen, 0, mapSize - 1);
        
        // Perform the lookup
        auto it = myMap.find(randomKey);
        if (it != myMap.end()) {
            benchmark::DoNotOptimize(it->second);  // Prevent the compiler from optimizing the lookup away
        }
    }
}
BENCHMARK(BM_MapLookup)->Range(8, 8 << r);  // Vary the map size from 8 to 8192
{% endhighlight %}
{% highlight c++ %}
// Benchmark function to measure the lookup time for a random element in a vector of pairs
static void BM_VectorLookup(benchmark::State& state) {
    // Generate a vector of pairs of the specified size
    std::vector<std::pair<int, int>> myVector;
    const int vectorSize = state.range(0);
    for (int i = 0; i < vectorSize; ++i) {
        myVector.emplace_back(i, i);
    }

    // Random number generator
    std::random_device rd;
    std::mt19937 gen(rd());

    // Perform lookup benchmarks
    for (auto _ : state) {
        // Generate a random key within the range of the vector
        int randomKey = generateRandomInt(gen, 0, vectorSize - 1);
        
        // Perform the lookup
        auto it = std::find_if(myVector.begin(), myVector.end(), [randomKey](const std::pair<int, int>& pair) {
            return pair.first == randomKey;
        });
        if (it != myVector.end()) {
            benchmark::DoNotOptimize(it->second);  // Prevent the compiler from optimizing the lookup away
        }
    }
}
BENCHMARK(BM_VectorLookup)->Range(8, 8 << 15);  // Vary the vector size from 8 to 8192

BENCHMARK_MAIN();
{% endhighlight %}


Benchmark Results
```
Run on (36 X 3000 MHz CPU s)
CPU Caches:
  L1 Data 32 KiB (x18)
  L1 Instruction 32 KiB (x18)
  L2 Unified 1024 KiB (x18)
  L3 Unified 25344 KiB (x1)
Load Average: 0.85, 0.97, 0.80
------------------------------------------------------------------------
Benchmark                              Time             CPU   Iterations
------------------------------------------------------------------------
BM_UnorderedMapLookup/8               130 ns          130 ns      5387512
BM_UnorderedMapLookup/64              130 ns          130 ns      5404746
BM_UnorderedMapLookup/512             130 ns          130 ns      5375510
BM_UnorderedMapLookup/4096            135 ns          135 ns      5189464
BM_UnorderedMapLookup/32768           146 ns          146 ns      4797892
BM_UnorderedMapLookup/262144          250 ns          250 ns      2756256
BM_UnorderedMapLookup/2097152         363 ns          363 ns      1914136
BM_UnorderedMapLookup/16777216        415 ns          415 ns      1607616
BM_UnorderedMapLookup/33554432        426 ns          426 ns      1641346
BM_MapLookup/8                        147 ns          147 ns      4760940
BM_MapLookup/64                       203 ns          203 ns      3440211
BM_MapLookup/512                      269 ns          269 ns      2606323
BM_MapLookup/4096                     328 ns          328 ns      2132072
BM_MapLookup/32768                    437 ns          437 ns      1542210
BM_MapLookup/262144                   708 ns          708 ns       845495
BM_MapLookup/2097152                 1255 ns         1255 ns       539855
BM_MapLookup/8388608                 1612 ns         1612 ns       437448
BM_VectorLookup/8                     115 ns          115 ns      6063751
BM_VectorLookup/64                    267 ns          267 ns      2528761
BM_VectorLookup/512                  1507 ns         1507 ns       464580
BM_VectorLookup/4096                11462 ns        11462 ns        60628
BM_VectorLookup/32768               90815 ns        90815 ns         8023
BM_VectorLookup/262144             727579 ns       727579 ns         1127
```

Plots:

![all plots](/assets/images/all_cache.png)

![map plots](/assets/images/map_cache.png)

![hashmap plot](/assets/images/hash_cache.png)



(Sorry if you're seeing this at an intermediate stage; I don't have any words just yet -- just data)