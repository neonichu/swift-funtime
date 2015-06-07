#!/usr/bin/xcrun swift

import Darwin

// thx Mike Ash (https://github.com/mikeash/memorydumper)
func symbolInfo(address: UInt) -> Dl_info? {
    var info = Dl_info(dli_fname: "", dli_fbase: nil, dli_sname: "", dli_saddr: nil)
    let ptr: UnsafePointer<Void> = unsafeBitCast(address, UnsafePointer<Void>.self)
    let result = dladdr(ptr, &info)
    return (result == 0 ? nil : info)
}

extension COpaquePointer: Printable {
    public var description: String {
        let info = symbolInfo(unsafeBitCast(self, UInt.self))

        if let symInfo = info {
            let lib_name = String.fromCString(symInfo.dli_fname)!
            let func_name = String.fromCString(symInfo.dli_sname)!
            return "Function '\(func_name)' from '\(lib_name)'"
        }

        return debugDescription
    }

    public init(_ library: String, _ symbol: String) {
        let handle = dlopen(library, RTLD_NOW)
        let sym = dlsym(handle, symbol)
        self.init(sym)
    }
}

// ------------------------------------------------------------------------




let handle = dlopen("/usr/lib/libc.dylib", RTLD_NOW)
let sym = dlsym(handle, "random")
//let pointer  = COpaquePointer(sym)

let pointer = COpaquePointer("/usr/lib/libc.dylib", "random")
println(pointer.description)
exit(0)





let rawPointer = UnsafeMutablePointer<() -> CLong>(sym)
let opaquePointer = COpaquePointer(rawPointer)
let functionPointer = CFunctionPointer<() -> CLong>(opaquePointer)

println(functionPointer)

/*let result : CLong = rawPointer.memory()
println(result)*/


func callf(f: () -> ()) {
    f();
}

typealias fpointer = () -> ()
println(sizeof(functionPointer.dynamicType))
println(sizeof(fpointer))

/*let functionPointer = unsafeBitCast(rawPointer, fpointer.self)
callf(functionPointer)*/

let cstr = symbolInfo(unsafeBitCast(rawPointer, UInt.self))?.dli_sname
println(String.fromCString(cstr!))



@asmname("random") func random2() -> CLong
@asmname("srandomdev") func srandomdev() -> Void

println(sizeof(random2.dynamicType))
println(random2())


struct swift_func_object {
    let original_type_ptr : COpaquePointer
    let function_address : COpaquePointer
}

struct bar {
    let ptr0: COpaquePointer
    let ptr1: COpaquePointer
    let function_pointer: COpaquePointer
}

println(sizeof(swift_func_object))

var ptr = unsafeBitCast(random2, swift_func_object.self)
println(ptr.original_type_ptr)
println(ptr.function_address)

/*ptr = unsafeBitCast(srandomdev, swift_func_object.self)
println(ptr.original_type_ptr)
println(ptr.function_address)*/

let aptr = UnsafeMutablePointer<bar>(ptr.function_address)
let aptr2 = aptr.memory
println(aptr2.function_pointer)


let v = unsafeBitCast(aptr2.function_pointer, UInt.self)
let v2 = COpaquePointer(bitPattern: v)
println(v2)

let symInfo = symbolInfo(v)
println(String.fromCString((symInfo?.dli_sname)!))





/*let my_ptr = swift_func_object(original_type_ptr: COpaquePointer(bitPattern: 0),
    function_address: COpaquePointer(bitPattern: 0x00007fff8e6aac7a))
let my_fpointer = unsafeBitCast(my_ptr, fpointer.self)
callf(my_fpointer)*/
