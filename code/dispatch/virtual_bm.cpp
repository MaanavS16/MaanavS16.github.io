#include <benchmark/benchmark.h>

// Define a base class with a virtual method
class Base {
public:
    virtual int virtualMethod() {
        return 42;
    }
};

// Define a derived class that overrides the virtual method
class Derived : public Base {
public:
    int virtualMethod() override {
        return 43;
    }
};

// Define a non-virtual function
int nonVirtualFunction(Base* obj) {
    return 42;
}

// Benchmark function to measure the latency of calling the virtual method
static void BM_VirtualMethodCall(benchmark::State& state) {
    Base* obj = new Derived();  // Creating an instance of the derived class

    for (auto _ : state) {
        // Measure the latency of calling the virtual method
        benchmark::DoNotOptimize(obj->virtualMethod());
    }

    delete obj;  // Clean up the allocated object
}

// Benchmark function to measure the latency of calling the non-virtual function
static void BM_NonVirtualFunctionCall(benchmark::State& state) {
    Base* obj = new Derived();  // Creating an instance of the derived class

    for (auto _ : state) {
        // Measure the latency of calling the non-virtual function
        benchmark::DoNotOptimize(nonVirtualFunction(obj));
    }

    delete obj;  // Clean up the allocated object
}

// Register the benchmarks
BENCHMARK(BM_VirtualMethodCall);
BENCHMARK(BM_NonVirtualFunctionCall);

// Run the benchmarks
BENCHMARK_MAIN();