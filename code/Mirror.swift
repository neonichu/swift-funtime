#!/usr/bin/xcrun swift

var mirror = ["a", "b"].getMirror()

println(mirror.summary)

for i in 0..<mirror.count {
    let (unknown, submirror) = mirror[i]
    println(submirror.summary)
}
