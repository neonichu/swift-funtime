# Swift funtime 🎉

## SwiftSummit, March 2015

### Boris Bügling - @NeoNacho

![20%, original, inline](images/contentful.png)

![](images/taylor-swift.jpg)

<!--- use Poster theme, white -->

---

## CocoaPods

![](images/cocoapods.jpg)

---

## Contentful

![](images/contentful-bg.png)

---

# 💖

![](images/swift.gif)

---

![](images/questions.gif)

---

# What is a Swift object even?

![](images/taylor3.jpg)

---

# Is it a bar?

![](images/bar.jpg)

---

# It depends

![](images/taylor4.jpg)

---

```
class MyObject : NSObject {
}
```

![](images/taylor5.jpg)

---

- behaves like any old Objective-C object
- instance variables are *properties*
- fully interopable with ObjC

![](images/taylor6.jpg)

---

```
import ObjectiveC.runtime
```

🎉

![](images/taylor7.jpg)

---

```
class MyObject {
}
```

![](images/taylor-swift.jpg)

---

- has *SwiftObject* as superclass
- instance variables are *ivars* only
- ivars have no type encoding
- methods are **not** ObjC methods
- not interoperable with ObjC

![](images/taylor2.jpg)

---

### SwiftObject

```
Ivar: magic {SwiftObject_s="isa"^v"refCount"q}
Protocol: NSObject
```

### NSObject

```
Ivar: isa #
Protocol: NSObject
```

![](images/taylor3.jpg)

---

# How does bridging work, then?

![inline](images/work.gif)

---

# It doesn't

![](images/azb6mBK_460sa_v1.gif)

---

```swift
func info<T>(x: T) {
    println("\(x) is a \(_stdlib_getDemangledTypeName(x))")
}
 
 
let array = [0, 1, 2] // 'as AnyObject' => 💥
info(array) // is a Swift.Array
 
import Foundation
 
let objc_array: AnyObject = [0, 1, 2] as AnyObject
info(objc_array) // is a Swift._NSSwiftArrayImpl
 
// comparing different array types => compiler error as well
//let equal = objc_array == array
```

![](images/swift-bg.jpg)

---

# Y did we 💖 the Objective-🐲 runtime?

- Dynamic Introspection 🔍
- Change Behaviour 🐒🔧
- Analyse private API 👹

![](images/taylor2.jpg)

---

# Dynamic introspection

![](images/taylor-swift.jpg)

---

```swift
var propertyCount : UInt32 = 0
var properties : UnsafeMutablePointer<objc_property_t> = 
    class_copyPropertyList(myClass, &propertyCount)

for i in 0..<propertyCount {
    println("Property: " + 
    String.fromCString(property_getName(properties[Int(i)]))!)
}
```

![](images/swift-bg.jpg)

---

## In pure Swift => 😭

![](images/taylor4.jpg)

---

## There is hope

```swift
// Excerpt from the standard library

/// How children of this value should be presented in the IDE.
enum MirrorDisposition {
    case Struct
    case Class
    case Enum
    [...]
}

/// A protocol that provides a reflection interface to an underlying value.
protocol MirrorType {
    [...]
}
```

![](images/swift-bg.jpg)

---

```swift
infix operator --> {}
func --> (instance: Any, key: String) -> Any? {
    let mirror = reflect(instance)

    for index in 0 ..< mirror.count {
        let (childKey, childMirror) = mirror[index]
        if childKey == key {
            return childMirror.value
        }
    }

    return nil
}
```

![](images/swift-bg.jpg)

---

```swift
struct MyPoint {
    let x: Float
    let y: Float
}

let point = MyPoint(x: 1, y: 2)
println(point --> "x") // Optional(1.0)
println(point --> "y") // Optional(2.0)
```

![](images/swift-bg.jpg)

---

# Change behaviour

![](images/taylor5.jpg)

---

```swift
let myString = "foobar" as NSString

println(myString.description) // foobar

let myBlock : @objc_block (AnyObject!) -> String = { (sself : AnyObject!) -> (String) in
    "✋"
}

let myIMP = imp_implementationWithBlock(unsafeBitCast(myBlock, AnyObject.self))
let method = class_getInstanceMethod(myString.dynamicType, "description")
method_setImplementation(method, myIMP)

println(myString.description) // ✋
```

![](images/swift-bg.jpg)

---

### NSInvocation does not exist

![200%](images/WcCXCSZ.gif)

---

# What about pure Swift?

![](images/taylor6.jpg)

---

# SWRoute

- PoC of function hooking in Swift
- Uses `rd_route`, a Mach specific injection library for C

![](images/taylor7.jpg)

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
```

![](images/swift-bg.jpg)

---

```c
uintptr_t _rd_get_func_impl(void *func) {
    struct swift_func_object *obj = (struct swift_func_object *)
        *(uintptr_t *)(func + kObjectFieldOffset);

    return obj->function_address;
}
```

![](images/swift-bg.jpg)

---

# Let's do that in Swift

![](images/taylor-swift.jpg)

---

# Memory layout

- 8 bytes => Pointer to `_TPA__TTRXFo_dSidSi_dSi_XFo_iTSiSi__iSi_`
- 8 bytes => Pointer to struct

```
_TPA__TTRXFo_dSidSi_dSi_XFo_iTSiSi__iSi_ ---> 
partial apply forwarder for reabstraction thunk helper 
[...]
```

![](images/swift-bg.jpg)

---

# Memory layout

- 16 bytes => Swift object
- 8 bytes => Pointer to `_TF6memory3addFTSiSi_Si`

__Function pointer__ 🎉

![](images/swift-bg.jpg)

---

```swift
struct f_trampoline {
    var trampoline_ptr: COpaquePointer
    var function_obj_ptr: UnsafeMutablePointer<function_obj>
}

struct function_obj {
    var some_ptr_0: COpaquePointer
    var some_ptr_1: COpaquePointer
    var function_ptr: COpaquePointer
}
```

![](images/swift-bg.jpg)

---

```swift
@asmname("floor") func my_floor(dbl: Double) -> Double
println(my_floor(6.7))

let handle = dlopen(nil, RTLD_NOW)
let pointer = COpaquePointer(dlsym(handle, "ceil"))

typealias FunctionType = (Double) -> Double
```

![](images/swift-bg.jpg)

---

```swift
struct f_trampoline { [...] }
struct function_obj { [...] }

let orig = unsafeBitCast(my_floor, f_trampoline.self)
let new = f_trampoline(prototype: orig, new_fp: pointer)
let my_ceil = unsafeBitCast(new, FunctionType.self)
println(my_ceil(6.7))
```

![](images/swift-bg.jpg)

---

```
$ xcrun swift -Onone hook.swift 
6.0
7.0
```

![](images/swift-bg.jpg)

---

# Can we do this the other way around?

![](images/taylor2.jpg)

---

```c
void executeFunction(void(*f)(void)) {
    f();
}
```

```swift
@asmname("executeFunction") func 
executeFunction(fp: CFunctionPointer<()->()>)
```

![](images/swift-bg.jpg)

---

```swift
func greeting() {
    println("Hello from Swift")
}

let t = unsafeBitCast(greeting, f_trampoline.self)
let fp = CFunctionPointer<()->()>
    (t.function_obj_ptr.memory.function_ptr)
executeFunction(fp)
```

```
Hello from Swift
Program ended with exit code: 0
```

![](images/swift-bg.jpg)

---

# Analyse private API

![](images/taylor3.jpg)

---

```swift
class MyClass {
  var someVar = 1

  func someFuncWithAReallyLongNameLol() {
  }
}
```

![](images/swift-bg.jpg)

---

```bash
$ xcrun swiftc f.swift 
$ ./swift-dump.rb f
// Code generated from `f`
import Foundation

class MyClass {
var someVar: Int = 0 
func someFuncWithAReallyLongNameLol() -> () {}
}
```

![](images/swift-bg.jpg)

----

```bash
$ xcrun nm -g f|grep TFC
0000000100000c50 T __TFC1f7MyClass30someFuncWithAReallyLongNameLolfS0_FT_T_
0000000100000d30 T __TFC1f7MyClassCfMS0_FT_S0_
0000000100000c70 T __TFC1f7MyClassD
0000000100000d10 T __TFC1f7MyClasscfMS0_FT_S0_
0000000100000c60 T __TFC1f7MyClassd
0000000100000ca0 T __TFC1f7MyClassg7someVarSi
0000000100000ce0 T __TFC1f7MyClassm7someVarSi
0000000100000cc0 T __TFC1f7MyClasss7someVarSi
```

![](images/swift-bg.jpg)

---

```bash
$ xcrun swift-demangle __TFC1f7MyClassg7someVarSi
_TFC1f7MyClassg7someVarSi ---> f.MyClass.someVar.getter : Swift.Int
```

![](images/swift-bg.jpg)

---

# How are emoji formed?

```
$ echo 'class 👍 {}'|xcrun swiftc -emit-library -o test -
$ nm -g test
...
0000000000000db0 T __TFC4testX4ypIhD
...
$ xcrun swift-demangle __TFC4testX4ypIhD
_TFC4testX4ypIhD ---> test.👍.__deallocating_deinit
```

*X4 ypIh* ~ *xn--yp8h*

![](images/taylor4.jpg)

---

# What have we learned?

- `import ObjectiveC.runtime` ☺️
- Introspection somewhat exists 😐
- Changing behaviour is hard  😖
- Reverse engineering is still fine 😅

![](images/taylor8.jpg)

---

# Thank you!

![](images/dance.gif)

---

- https://github.com/mikeash/memorydumper
- http://airspeedvelocity.net/
- https://developer.apple.com/swift/blog/
- http://www.russbishop.net/swift-how-did-i-do-horrible-things

![](images/taylor5.jpg)

---

@NeoNacho

boris@contentful.com

http://buegling.com/talks

http://www.contentful.com

![](images/taylor6.jpg)
