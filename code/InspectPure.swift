#!/usr/bin/xcrun swift

class Foo {
  func bar() {
  }
}

let f = Foo()

import Foundation

println(f.dynamicType)
println(CFunctionPointer<(() -> ())>.self)
println([Int].self)
