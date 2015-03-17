#!/usr/bin/xcrun swift

import Foundation
import ObjectiveC.runtime

class MyObject {}

var ivarCount : UInt32 = 0
var ivars : UnsafeMutablePointer<Ivar> = class_copyIvarList(class_getSuperclass(MyObject.self), &ivarCount)

for i in 0..<ivarCount {
    print("Ivar: " + String.fromCString(ivar_getName(ivars[Int(i)]))!)
    println(" " + String.fromCString(ivar_getTypeEncoding(ivars[Int(i)]))!)
}
