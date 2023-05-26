---
layout: single
classes: wide
title:  "Reverse Engineering Memory"
date:   2023-05-23 15:23:54 -0400
categories: systems embedded
---

Caches, SSDs, and Disks are fundamental to application performance. Here I conduct a set of experiments to isolate and understand these components.

***
Memory is absolutely essential in the field of computing. From an automata theory standpoint, it's the key tool that enables us to reason with context-free and recursively enumerable languages. Beyond the theoretical power memory yields, the performance characteristics of various memory models and techniques heavily influence modern software.

My goal with these experiments is to fill in some of the holes in my knowledge with some hands on analysis with some documentation I can reference in the future.Before diving into the details I'd like to do a bottom-up review of computer memory in general. 

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


> All following benchmarks will be run on a single thread of an i9-10980XE processor
> 2x32 GB DDR4 Memory @ 2666 MHZ
