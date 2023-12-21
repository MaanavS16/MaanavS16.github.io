#include <iostream>

class Animal {
public:
    virtual void makeNoise() const {
        std::cout << "????" << std::endl;
    }

    // Non-virtual function
    int id() const {
        return 0;
    }
};

class Cat : public Animal {
public:
    // Override the virtual function. Dynamically dispatched at runtime
    void makeNoise() const override {
        std::cout << "Meow :3" << std::endl;
    }

    int id() const {
        return 1;
    }
};


int main() {
    Cat* cat = new Cat();
    Animal* animalCat = (Animal*) cat;

    std::cout << cat->id() << std::endl;
    // Output: 1
    // Explanation: This object is referenced as Cat*, so the Cat.id method is statically dispatched.

    std::cout << animalCat->id() << std::endl;
    // Output: 0
    // Explanation: This object is referenced as Animal*, so the Animal.id method is statically dispatched.

    cat->makeNoise();
    // Output: Meow :3
    // Explanation: This object is referenced as Cat*, so the Cat.makeNoise method is statically dispatched

    animalCat->makeNoise();
    // Output: Meow :3
    // Explanation: This method is marked virtual in Animal, so the Cat.makeNoise method is dynamically dispatched
}