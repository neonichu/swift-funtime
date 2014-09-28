#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface MyClass : NSObject

@property (nonatomic, retain) NSString* foo;

@end

#pragma mark -

@implementation MyClass

-(instancetype)init {
    self = [super init];
    if (self) {
        self.foo = @"bar";
    }
    return self;
}

@end

#pragma mark -

int main(int argc, char *argv[])
{
    @autoreleasepool {
        MyClass* object = [MyClass new];
        Ivar ivar = class_getInstanceVariable(object.class, "_foo");
        id value = object_getIvar(object, ivar);
        NSLog(@"%@", value);
        return 0;
    }
}

// clang Ivar.m -framework Foundation
