#!/usr/bin/xcrun swift

// From: https://gist.github.com/peebsjs/9288f79322ed3119ece4

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

//Example
struct MyPoint {
    let x: Float
    let y: Float
}

let point = MyPoint(x: 1, y: 2)
println(point --> "x")
println(point --> "y")
