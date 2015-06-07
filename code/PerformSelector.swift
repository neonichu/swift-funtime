#!/usr/bin/env DEVELOPER_DIR=/Applications/Xcode-6.2.app/Contents/Developer xcrun swift

import Foundation
import ObjectiveC.runtime

// This crashes ILGenerator on Swift 1.2
@asmname("objc_msgSend") func sendPerformSelector(NSObject, Selector, Selector) -> NSString

extension NSObject {
	// Using `performSelector` crashes in 1.1
    public func performSelector2(selector : Selector) -> NSString {
        return sendPerformSelector(self, "performSelector:", selector)
    }
}

let string : NSString = "Fuck yeah, Swift!"
println(string.performSelector2("description"))
