# Swift funtime 🎉

## AltConf, June 2015

### Boris Bügling - @NeoNacho

![20%, original, inline](images/contentful.png)

![](images/taylor-laughing.gif)

<!--- use Poster theme, black -->

---

![](images/hi.gif)

---

![inline, 200%](images/cocoapods.png)

---

## Contentful

![](images/contentful-bg.png)

---

![120%](images/contentful-bg-2.png)

---

# 💖

![](images/swift-2.gif)

---

![](images/questions.gif)

---

# What is a Swift object even?

![](images/object.gif)

---

# It depends

![](images/it_depends.gif)

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

![](images/mind_blown.gif)

---

```swift
func info<T>(x: T) {
    print("\(x) is a \(_stdlib_getDemangledTypeName(x))")
}
 
 
let array = [0, 1, 2] // 'as AnyObject' => 💥
info(array) // is a Swift.Array
 
import Foundation
 
let objc_array: AnyObject = [0, 1, 2] as AnyObject
info(objc_array) // is a Swift._NSSwiftArrayImpl
 
// comparing different array types => compiler error as well
//let equal = objc_array == array
```

![](images/swift-bg-2.jpg)

---

## 🎉

![](images/party.gif)

---

# Swift 2.0

```bash
./foo.swift:3:17: error: 'CFunctionPointer' is unavailable:
use a function type '@convention(c) (T) -> U'
typealias foo = CFunctionPointer<() -> ()>
```

![](images/swift-bg-2.jpg)

---

![](images/f-u.gif)

---

```swift
@convention(swift)
```

> Apply this attribute to the type of the function to indicate its calling conventions.

![](images/swift-bg-2.jpg)

---

# C function pointers

## Swift 1.x

```swift
CFunctionPointer<(UnsafeMutablePointer<Void>, Float) -> Int>.self
```

## Swift 2.x

```swift
typealias CFunction = @convention(c) (UnsafeMutablePointer<Void>, Float) -> Int
CFunction.self
```

![](images/swift-bg-2.jpg)

---

# Objective-C blocks

## Swift 1.x

```swift
@objc_block ...
```

## Swift 2.x

```swift
@convention(block)
```

![](images/swift-bg-2.jpg)

---

![](images/yay.gif)

---

# Y did we 💖 the Objective-🐲 runtime?

- Dynamic Introspection 🔍
- Change Behaviour 🐒🔧
- Analyse private API 👹

![](images/taylor2.jpg)

---

![](images/get_started.gif)

---

# Dynamic introspection

![](images/introspection.gif)

---

```swift
var propertyCount : UInt32 = 0
var properties : UnsafeMutablePointer<objc_property_t> = 
    class_copyPropertyList(myClass, &propertyCount)

for i in 0..<propertyCount {
    print("Property: " + 
    String.fromCString(property_getName(properties[Int(i)]))!)
}
```

![](images/swift-bg-2.jpg)

---

## In pure Swift => 😭

![](images/womp.gif)

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

![](images/swift-bg-2.jpg)

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

![](images/swift-bg-2.jpg)

---

```swift
struct MyPoint {
    let x: Float
    let y: Float
}

let point = MyPoint(x: 1, y: 2)
print(point --> "x") // Optional(1.0)
print(point --> "y") // Optional(2.0)
```

![](images/swift-bg-2.jpg)

---

![](images/oYK11dXjrkXh6.gif)

---

# Change behaviour

![](images/change.gif)

---

```swift
let myString = "foobar" as NSString

print(myString.description) // foobar

let myBlock : @convention(block) (AnyObject!) -> String = { (sself : AnyObject!) -> (String) in
    "✋"
}

let myIMP = imp_implementationWithBlock(unsafeBitCast(myBlock, AnyObject.self))
let method = class_getInstanceMethod(myString.dynamicType, "description")
method_setImplementation(method, myIMP)

print(myString.description) // ✋
```

![](images/swift-bg-2.jpg)

---

### NSInvocation does not exist

![](images/oh_no.gif)

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

![](images/swift-bg-2.jpg)

---

```c
uintptr_t _rd_get_func_impl(void *func) {
    struct swift_func_object *obj = (struct swift_func_object *)
        *(uintptr_t *)(func + kObjectFieldOffset);

    return obj->function_address;
}
```

![](images/swift-bg-2.jpg)

---

![](images/explain.gif)

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

![](images/swift-bg-2.jpg)

---

# Memory layout

- 16 bytes => Swift object
- 8 bytes => Pointer to `_TF6memory3addFTSiSi_Si`

__Function pointer__ 🎉

![](images/swift-bg-2.jpg)

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

![](images/swift-bg-2.jpg)

---

```swift
@asmname("floor") func my_floor(dbl: Double) -> Double
print(my_floor(6.7))

let handle = dlopen(nil, RTLD_NOW)
let pointer = COpaquePointer(dlsym(handle, "ceil"))

typealias FunctionType = (Double) -> Double
```

![](images/swift-bg-2.jpg)

---

```swift
struct f_trampoline { [...] }
struct function_obj { [...] }

let orig = unsafeBitCast(my_floor, f_trampoline.self)
let new = f_trampoline(prototype: orig, new_fp: pointer)
let my_ceil = unsafeBitCast(new, FunctionType.self)
print(my_ceil(6.7))
```

![](images/swift-bg-2.jpg)

---

```
$ xcrun swift -Onone hook.swift 
6.0
7.0
```

![](images/swift-bg-2.jpg)

---

![](images/hook.gif)

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
typealias CFunc = @convention(c) ()->()

@asmname("executeFunction") func 
executeFunction(fp: CFunc)
```

![](images/swift-bg-2.jpg)

---

```swift
func greeting() {
    print("Hello from Swift")
}

typealias CFunc = @convention(c) ()->()

let t = unsafeBitCast(greeting, f_trampoline.self)
let fp = unsafeBitCast(t.function_obj_ptr.memory.function_ptr, CFunc.self)
executeFunction(fp)
```

```
Hello from Swift
Program ended with exit code: 0
```

![](images/swift-bg-2.jpg)

---

![](images/69H4bMsuQk2S4.gif)

---

# Analyse private API

![](images/taylor3.jpg)

---

![](images/cut-throat.gif)

---

```swift
class MyClass {
  var someVar = 1

  func someFuncWithAReallyLongNameLol() {
  }
}
```

![](images/swift-bg-2.jpg)

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

![](images/swift-bg-2.jpg)

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

![](images/swift-bg-2.jpg)

---

```bash
$ xcrun swift-demangle __TFC1f7MyClassg7someVarSi
_TFC1f7MyClassg7someVarSi ---> f.MyClass.someVar.getter : Swift.Int
```

![](images/swift-bg-2.jpg)

---

![](images/Q24x3MLQYi2Hu.gif)

---

# `performSelector`?

```swift
import Foundation
import ObjectiveC.runtime

@asmname("objc_msgSend") func sendPerformSelector(NSObject, Selector, Selector) -> NSString

extension NSObject {
    public func performSelector2(selector : Selector) -> NSString {
        return sendPerformSelector(self, "performSelector:", selector)
    }
}

let string : NSString = "Fuck yeah, Swift!"
println(string.performSelector2("description"))
```

![](images/swift-bg-2.jpg)

---

# 😱

```bash
1.  While emitting IR SIL function
@_TFE15PerformSelectorCSo8NSObject16performSelector2fS0_FV10ObjectiveC8SelectorCSo8NSString 
for 'performSelector2' at ./PerformSelector.swift:13:12
Abort trap: 6
```

![](images/swift-bg-2.jpg)

---

![](images/noooooo.gif)

---

# Only works with Swift 1.1 :(

```swift
#!/usr/bin/env
DEVELOPER_DIR=/Applications/Xcode-6.2.app/Contents/Developer
xcrun swift
```

![](images/swift-bg-2.jpg)

---

```bash
$ ./PerformSelector.swift 
Fuck yeah, Swift
```

![](images/swift-bg-2.jpg)

---

![](images/azMA2znY9euje.gif)

---

# Why `func performSelector2` ?

```bash
$ ./PerformSelector.swift 
Segmentation fault: 11
```

![](images/swift-bg-2.jpg)

---

![](images/rxQofqSkFZpNm.gif)

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

![](images/pAfqXBzJaboIg.gif)

---

# What have we learned?

- `import ObjectiveC.runtime` ☺️
- Introspection somewhat exists 😐
- Changing behaviour is hard  😖
- Reverse engineering is still fine 😅

![](images/taylor8.jpg)

---

# Thank you!

![](images/thanks.gif)

---

- http://airspeedvelocity.net/
- http://www.russbishop.net/swift-how-did-i-do-horrible-things
- https://github.com/mikeash/memorydumper
- https://github.com/rodionovd/SWRoute

![](images/taylor5.jpg)

---

@NeoNacho

boris@contentful.com

http://buegling.com/talks

http://www.contentful.com

![](images/bye.gif)
