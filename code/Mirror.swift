#!/usr/bin/xcrun swift

var mirror = ["a", "b"].getMirror()

print(mirror.summary)

for i in 0..<mirror.count {
    let (unknown, submirror) = mirror[i]
    print(submirror.summary)
}
