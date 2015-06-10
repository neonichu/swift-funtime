#!/usr/bin/xcrun swift

class Foo {
  func bar() {
  }
}

let f = Foo()

import Foundation

typealias CFunction = @convention(c) () -> ()

print(f.dynamicType)
print(CFunction.self)
print([Int].self)
