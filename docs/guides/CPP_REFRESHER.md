---
layout: default
title: C++ Quick Refresher - HoaLibrary
---

# C++ Quick Refresher Guide

**For developers coming back to C++ after PHP/Laravel** 🚀

*Perfect for understanding the HoaLibrary C++ codebase*

---

## Table of Contents

1. [.h vs .cpp Files](#h-vs-cpp-files)
2. [Function Declarations vs Definitions](#function-declarations-vs-definitions)
3. [Pointers & References](#pointers--references)
4. [Classes & Objects](#classes--objects)
5. [Templates (Generics)](#templates-generics)
6. [Memory Management](#memory-management)
7. [HoaLibrary Specific Patterns](#hoalibrary-specific-patterns)

---

## .h vs .cpp Files

### The Basic Difference

```cpp
// ============================================
// MyClass.h (Header file)
// ============================================
// WHAT the class/functions are (declarations)
// Like a PHP interface or method signatures

#ifndef MYCLASS_H    // Include guard (prevents double-inclusion)
#define MYCLASS_H

class MyClass {
public:
    void doSomething(int x);      // Declaration
    int calculate(float y);       // Declaration
    
private:
    int m_value;                  // Member variable
};

#endif
```

```cpp
// ============================================
// MyClass.cpp (Implementation file)
// ============================================
// HOW the functions work (definitions)
// Like a PHP class with actual code

#include "MyClass.h"

void MyClass::doSomething(int x) {   // Definition
    m_value = x * 2;
    // actual implementation here
}

int MyClass::calculate(float y) {    // Definition
    return m_value + static_cast<int>(y);
}
```

### PHP Comparison

```php
<?php
// PHP doesn't split declarations and implementations
// Everything is in one file:

class MyClass {
    private $value;
    
    public function doSomething($x) {    // Declaration + Implementation together
        $this->value = $x * 2;
    }
    
    public function calculate($y) {
        return $this->value + intval($y);
    }
}
```

### Why Split Them?

| Reason | Explanation |
|--------|-------------|
| **Compilation speed** | Only recompile .cpp if implementation changes |
| **API clarity** | .h shows public interface (like API docs) |
| **Separation** | Declaration = contract, Implementation = details |

---

## Function Declarations vs Definitions

### Declaration (in .h)
```cpp
// Says "this function exists" but not HOW it works
int add(int a, int b);                  // Semicolon = declaration
float calculate(float x, float y);      // Just the signature
```

### Definition (in .cpp or .h)
```cpp
// Shows HOW it works (the actual code)
int add(int a, int b) {                 // Curly braces = definition
    return a + b;
}

float calculate(float x, float y) {
    return x * 2.0f + y;
}
```

### PHP Equivalent
```php
<?php
// PHP doesn't have separate declarations
// You always write the full function:

function add($a, $b) {        // Declaration + Definition in one
    return $a + $b;
}
```

---

## Pointers & References

### The Basics

```cpp
// ============================================
// REGULAR VARIABLE (like PHP)
// ============================================
int x = 42;
// x contains the value 42 directly

// ============================================
// POINTER (stores memory address)
// ============================================
int* ptr = &x;       // ptr stores the ADDRESS of x
                     // & = "address of"
                     // * = "pointer to"

cout << ptr;         // Prints: 0x7fff5fbff8ac (memory address)
cout << *ptr;        // Prints: 42 (dereference = get value at address)

*ptr = 100;          // Change value at that address
cout << x;           // Prints: 100 (x was modified!)

// ============================================
// REFERENCE (alias to variable)
// ============================================
int& ref = x;        // ref is another name for x
ref = 200;           // Same as x = 200
cout << x;           // Prints: 200
```

### PHP Comparison

```php
<?php
// PHP has references but they're simpler:

$x = 42;
$ref = &$x;          // Reference (like C++ reference)
$ref = 100;          // $x is now 100

// PHP doesn't have explicit pointers (it's automatic)
// Objects are always passed by reference internally
```

### Visual Explanation

```
Memory Layout:

Address     Value
0x1000      42        ← x lives here
0x2000      0x1000    ← ptr stores x's address
                      ← ref is just another name for x (no separate storage)

After *ptr = 100:

Address     Value
0x1000      100       ← x changed (via pointer)
```

### Common Patterns

```cpp
// ============================================
// PASSING TO FUNCTIONS
// ============================================

// By value (copy) - Like PHP default for primitives
void function1(int x) {
    x = 100;         // Only changes local copy
}

// By pointer (can modify original)
void function2(int* x) {
    *x = 100;        // Changes original value
}

// By reference (can modify original, cleaner syntax)
void function3(int& x) {
    x = 100;         // Changes original value (no * needed)
}

// Usage:
int num = 42;
function1(num);      // num still 42
function2(&num);     // num now 100 (pass address with &)
function3(num);      // num now 100 (no & needed in call)
```

### PHP Equivalent

```php
<?php
// By value (default for primitives)
function function1($x) {
    $x = 100;        // Doesn't change original
}

// By reference (explicit &)
function function2(&$x) {
    $x = 100;        // Changes original
}

$num = 42;
function1($num);     // $num still 42
function2($num);     // $num now 100
```

---

## Classes & Objects

### Basic Class

```cpp
// ============================================
// Point.h
// ============================================
class Point {
public:
    // Constructor (like PHP __construct)
    Point(float x, float y);
    
    // Methods
    float getX() const;         // const = won't modify object
    void setX(float x);
    
    float distanceTo(const Point& other) const;
    
private:
    float m_x;                  // Member variables (m_ prefix common)
    float m_y;
};
```

```cpp
// ============================================
// Point.cpp
// ============================================
#include "Point.h"
#include <cmath>

// Constructor implementation
Point::Point(float x, float y) : m_x(x), m_y(y) {
    // Initializer list ^^^^^^^^^  (preferred way)
    // Empty body
}

float Point::getX() const {
    return m_x;
}

void Point::setX(float x) {
    m_x = x;
}

float Point::distanceTo(const Point& other) const {
    float dx = m_x - other.m_x;
    float dy = m_y - other.m_y;
    return sqrt(dx*dx + dy*dy);
}
```

### Using the Class

```cpp
// Create object (on stack)
Point p1(10.0f, 20.0f);
float x = p1.getX();          // No ->

// Create object (on heap with pointer)
Point* p2 = new Point(30.0f, 40.0f);
float y = p2->getX();         // Use -> for pointers
delete p2;                    // Must manually delete!
```

### PHP Equivalent

```php
<?php
class Point {
    private $x;
    private $y;
    
    public function __construct($x, $y) {
        $this->x = $x;
        $this->y = $y;
    }
    
    public function getX() {
        return $this->x;
    }
    
    public function setX($x) {
        $this->x = $x;
    }
    
    public function distanceTo(Point $other) {
        $dx = $this->x - $other->x;
        $dy = $this->y - $other->y;
        return sqrt($dx*$dx + $dy*$dy);
    }
}

// Usage
$p1 = new Point(10.0, 20.0);
$x = $p1->getX();             // Always use ->
// No need to delete (garbage collected)
```

---

## Templates (Generics)

Templates = C++'s version of PHP generics (but way more powerful)

### Basic Template

```cpp
// ============================================
// Generic function (works with any type)
// ============================================
template <typename T>
T add(T a, T b) {
    return a + b;
}

// Usage:
int result1 = add(5, 10);           // T = int
float result2 = add(3.14f, 2.86f);  // T = float
double result3 = add(1.5, 2.5);     // T = double
```

### Template Class

```cpp
// ============================================
// Generic container (like PHP array)
// ============================================
template <typename T>
class Container {
public:
    Container(int size) {
        m_data = new T[size];
        m_size = size;
    }
    
    ~Container() {              // Destructor (like PHP __destruct)
        delete[] m_data;
    }
    
    void set(int index, T value) {
        m_data[index] = value;
    }
    
    T get(int index) {
        return m_data[index];
    }
    
private:
    T* m_data;
    int m_size;
};

// Usage:
Container<int> intContainer(10);
intContainer.set(0, 42);

Container<float> floatContainer(5);
floatContainer.set(0, 3.14f);
```

### HoaLibrary Pattern

```cpp
// HoaLibrary uses templates heavily:

template <Dimension D, typename T>
class Encoder {
    // D = Hoa2d or Hoa3d
    // T = float or double
};

// Usage:
Encoder<Hoa2d, float>* encoder2d;        // 2D, float precision
Encoder<Hoa3d, double>* encoder3d;       // 3D, double precision
```

---

## Memory Management

### Stack vs Heap

```cpp
// ============================================
// STACK ALLOCATION (automatic, fast)
// ============================================
void function() {
    int x = 42;                  // Stack variable
    Point p(10, 20);             // Stack object
    
    // When function ends, x and p are AUTOMATICALLY destroyed
}

// ============================================
// HEAP ALLOCATION (manual, flexible)
// ============================================
void function() {
    int* x = new int(42);        // Heap variable
    Point* p = new Point(10, 20); // Heap object
    
    // ... use them ...
    
    delete x;                     // MUST manually delete!
    delete p;                     // Or memory leak!
}

// ============================================
// ARRAY ALLOCATION
// ============================================
int* arr1 = new int[100];        // Heap array
delete[] arr1;                   // Use delete[] for arrays!

int arr2[100];                   // Stack array (auto-destroyed)
```

---

## HoaLibrary Specific Patterns

### 1. Template Specialization

```cpp
// Generic template
template <Dimension D, typename T>
class Encoder;

// Specialization for 2D
template <typename T>
class Encoder<Hoa2d, T> {
    void setAzimuth(T angle);
};

// Usage:
Encoder<Hoa2d, float>* enc;
```

### 2. Nested Classes

```cpp
class Encoder {
public:
    class Basic;
    class DC;
};

// Usage:
Encoder::Basic* encoder;
```

---

## Quick Cheat Sheet

| C++ | PHP | Purpose |
|-----|-----|---------|
| `int x;` | `$x;` | Variable |
| `int* ptr;` | (no equivalent) | Pointer |
| `int& ref;` | `&$ref` | Reference |
| `new Object()` | `new Object()` | Heap allocation |
| `delete ptr;` | (automatic) | Free memory |
| `obj.method()` | `$obj->method()` | Call method (stack) |
| `ptr->method()` | `$obj->method()` | Call method (pointer) |
| `.h` file | (no equivalent) | Declarations |
| `.cpp` file | `.php` file | Implementation |
| `template<T>` | (limited) | Generics |

---

## Practice with HoaLibrary

```cpp
// Create encoder
Encoder<Hoa2d, float>::Basic* encoder;
encoder = new Encoder<Hoa2d, float>::Basic(7);

// Set angle
encoder->setAzimuth(1.57f);  // 90 degrees

// Process
float input[64];
float harmonics[15];
encoder->process(input, harmonics);

// Clean up
delete encoder;
```

---

**Ready to explore the [API Reference](API_REFERENCE.html)!** 🚀

<div class="back-nav">
  <a href="index.html">← Back to Documentation</a>
  <a href="API_REFERENCE.html">API Reference →</a>
</div>
