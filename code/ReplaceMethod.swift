#!/usr/bin/xcrun swift

import Foundation
import ObjectiveC.runtime

let myString = "foobar" as NSString

print(myString.description)

let myBlock : @convention(block) (AnyObject!) -> String = { (sself : AnyObject!) -> (String) in
    "✋"
}

let myIMP = imp_implementationWithBlock(unsafeBitCast(myBlock, AnyObject.self))
let method = class_getInstanceMethod(myString.dynamicType, "description")
method_setImplementation(method, myIMP)

print(myString.description)
