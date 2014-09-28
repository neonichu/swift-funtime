import Foundation
import ObjectiveC.runtime

let myString = "foobar" as NSString

println(myString.description)

let myIMP = imp_implementationWithBlock({ (sself : AnyObject!) -> (String) in
    "✋"
})

let method = class_getInstanceMethod(myString.dynamicType, "description")
method_setImplementation(method, myIMP)

println(myString.description)
