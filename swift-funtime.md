# Swift funtime

## mobiconf 2014

### Boris Bügling - @NeoNacho

![20%, original, inline](images/contentful.png)

![](images/swift-slide.png)

---

## CocoaPods

![](images/cocoapods.jpg)

---

## Contentful

![](images/contentful-bg.png)

---

## Swift

![](images/taylor-swift.jpg)

---

# Agenda

- How do you even Swift?
- What is a Swift object?
- Objective-C runtime in the age of Swift
- Swift runtime

![](images/swift-bg.jpg)

---

>> “Swift’s clean slate [...] is an opportunity to reimagine how software development works.”

![](images/swift-bg.jpg)

---

- Optionals
- Tuples
- Generics
- Pattern matching
- Operator overloading
- Namespaces
- Type inference
- ...

![](images/swift-bg.jpg)

---

# emoji identifiers! 🎉

```swift
class 🍷 {
    func 💥() {
    }
}
```

![](images/swift-bg.jpg)

---

# Interfaces with C, at full speed

## Watch *"Swift and C"* by Mike Ash

![left, fit](images/unsafe-tweet.png)

---

## Drops C++ interoperability

---

>> Everyone is a Beginner

![](images/veryfurrow.jpg)

---

- The Swift Programming Language *by *

### and also

- Swift by Tutorials: A Hands-On Approach
- Your First Swift App
- Functional Programming in Swift

---

![](images/rob.gif)

---

# What is a Swift object?

![](images/swift-bg.jpg)

---

# It depends

![](images/swift-bg.jpg)

---

```swift
class MyObject : NSObject {
}
```

![](images/swift-bg.jpg)

---

- has *NSObject* as superclass
- behaves like any old Objective-C object
- instance variables are *properties*
- fully interopable with ObjC

![](images/swift-bg.jpg)

---


```swift
class MyObject {
}
```

![](images/swift-bg.jpg)

---

- has *SwiftObject* as superclass
- instance variables are *ivars*
- methods are **not** ObjC methods
- not interoperable with ObjC

![](images/swift-bg.jpg)

---

### Playground!

```
import ObjectiveC.runtime
```

but

```
Playground execution failed: Error in auto-import:
failed to get module 'runtime' from AST context
```

---

# 😢🐼

---

### Demo: Inspect objects

---

### SwiftObject

Ivar: magic {SwiftObject_s="isa"^v"refCount"q}
Protocol: NSObject

### NSObject

Ivar: isa #
Protocol: NSObject

![](images/swift-bg.jpg)

---

```swift
class MySwiftClass {
    var foo = "bar";

    init() {
    }
}

import Foundation
import ObjectiveC.runtime

var ivar = class_getInstanceVariable(MySwiftClass().dynamicType, "foo")
var value : AnyObject = object_getIvar(MySwiftClass(), ivar)!
```

Segmentation fault: 11

---

# value types should be *structs*

```swift
struct MyObject {
}
```

![](images/swift-bg.jpg)

---

## In pure Swift, there's no introspection 😭

![](images/swift-bg.jpg)

---

# Objective-C runtime in the age of Swift

---

## Inherit from `NSObject` and it just works!

---

# Even swizzling 😱

---

```swift
import Foundation
import ObjectiveC.runtime

extension NSString {
    func swizzle_description() -> NSString {
        return "💥"
    }
}

var myString = "foobar" as NSString

println(myString.description)

var originalMethod = class_getInstanceMethod(NSString.self, "description")
var swizzledMethod = class_getInstanceMethod(NSString.self, "swizzle_description")

method_exchangeImplementations(originalMethod, swizzledMethod)

println(myString.description)
```

---

### Demo: dynamic table view

---

## But what can we do about pure Swift?

---

# SWRoute

PoC of function hooking in Swift

---

```c
#include <stdint.h>

#define kObjectFieldOffset sizeof(uintptr_t)

struct swift_func_object {
    uintptr_t *original_type_ptr;
#if defined(__x86_64__)
    uintptr_t *unknown0;
#else
    uintptr_t *unknown0, *unknown1;
#endif
    uintptr_t function_address;
    uintptr_t *self;
};

uintptr_t _rd_get_func_impl(void *func) {
    struct swift_func_object *obj = (struct swift_func_object *)*(uintptr_t *)(func + kObjectFieldOffset);

    return obj->function_address;
}
```

---

# Swift runtime

---

- libswiftCore.dylib

implementations of `NSSwiftArray`, etc.

- libswiftRuntime.a

low-level primitives like `swift_release`

---

## Compatibility

- App Compatibility ✅
- Binary Compatibility ⛔️
- Source Compatibility ⛔️

---

```
Foo.app boris$ find . -type f
./Frameworks/libswiftCore.dylib
./Frameworks/libswiftCoreGraphics.dylib
./Frameworks/libswiftCoreImage.dylib
./Frameworks/libswiftDarwin.dylib
./Frameworks/libswiftDispatch.dylib
./Frameworks/libswiftFoundation.dylib
./Frameworks/libswiftObjectiveC.dylib
./Frameworks/libswiftUIKit.dylib
./Info.plist
./PkgInfo
./Foo
```

---

# You don't need Objective-C anymore

![](images/25yuswsw28295.gif)

---

## Unless you build frameworks or need to work with C++

![left](images/5RSgg6y.gif)

---

## But the ObjC runtime is still strong

![right](images/shia-labeouf-magic-gif.gif)

---

# Thank you!

![](images/three-hands.gif)

---

@NeoNacho

boris@contentful.com

http://buegling.com/talks

