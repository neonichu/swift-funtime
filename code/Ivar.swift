class MySwiftClass /*: NSObject*/ {
    var foo = "bar";

    /*override*/ init() {
    }
}

import Foundation
import ObjectiveC.runtime

var ivar = class_getInstanceVariable(MySwiftClass().dynamicType, "foo")

println(NSString(CString: ivar_getName(ivar), encoding: NSUTF8StringEncoding)!)

var value : AnyObject = object_getIvar(MySwiftClass(), ivar)!

println(value)
