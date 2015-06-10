#!/usr/bin/xcrun swift

import Foundation
import ObjectiveC.runtime

func inspectClass(myClass : AnyObject.Type) -> Void {
    print("Name: " + NSStringFromClass(myClass))

    var ivarCount : UInt32 = 0
    var ivars : UnsafeMutablePointer<Ivar> = class_copyIvarList(myClass, &ivarCount)

    for i in 0..<ivarCount {
        print("Ivar: " + String.fromCString(ivar_getName(ivars[Int(i)]))!)
        print(" " + String.fromCString(ivar_getTypeEncoding(ivars[Int(i)]))!)
    }

    var propertyCount : UInt32 = 0
    var properties : UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(myClass,
        &propertyCount)

    for i in 0..<propertyCount {
        print("Property: " + String.fromCString(property_getName(properties[Int(i)]))!)
    }

    /*var methodCount : UInt32 = 0
    var methods : UnsafeMutablePointer<Method> = class_copyMethodList(myClass, &methodCount)

    for i in 0..<methodCount {
        print("Method: ")
        print(method_getName(methods[Int(i)]))
    }*/

    var protocolCount : UInt32 = 0
    var protocols : AutoreleasingUnsafeMutablePointer<Protocol?> = class_copyProtocolList(myClass,
        &protocolCount)

    for i in 0..<protocolCount {
        print("Protocol: " + String.fromCString(protocol_getName(protocols[Int(i)]))!)
    }
}

func inspect(obj : AnyObject) -> Void {
    // TODO: Missing in Swift 1.2
    //print("Mangled name: \(_stdlib_getTypeName(obj))")

    let myClass: AnyObject.Type = obj.dynamicType
    inspectClass(myClass)

    let superClass: AnyObject.Type = class_getSuperclass(myClass)
    inspectClass(superClass)
}

print("# Swift based class")

class MyObject {
    var foo : String = "foo"

    func bar(str : String) -> Bool {
        return false
    }

    init() {
    }
}

inspect(MyObject())

print("\n# Objective-C based class")

class MyNSObject : NSObject {
    var foo : String = "foo"

    func bar(str : String) -> Bool {
        return false
    }

    override init() {
    }
}

inspect(MyNSObject())

/*var foo = ["foo", "bar"]
inspect(foo)

var bar = ["foo": "bar"]
inspect(bar)*/

