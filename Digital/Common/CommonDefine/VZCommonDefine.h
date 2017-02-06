//
//  CommonDefine.h
//  minesweeper
//
//  Created by 张朴军 on 12-12-21.
//
//
#import <objc/runtime.h>

//#define DEBUG_MODE
#define SYSTEM_FONT NSLocalizedString(@"Berlin Sans FB",nil)  

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define VZSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)







#define CWL_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(classname, accessorMethodName) \
+ (classname *)accessorMethodName;

#if __has_feature(objc_arc)
#define CWL_SYNTHESIZE_SINGLETON_RETAIN_METHODS
#else
#define CWL_SYNTHESIZE_SINGLETON_RETAIN_METHODS \
- (id)retain \
{ \
    return self; \
} \
\
- (NSUInteger)retainCount \
{ \
    return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
    return self; \
}
#endif

#define CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(classname, accessorMethodName) \
\
static classname *accessorMethodName##Instance = nil; \
\
+ (classname *)accessorMethodName \
{ \
    @synchronized(self) \
    { \
        if (accessorMethodName##Instance == nil) \
        { \
            accessorMethodName##Instance = [super allocWithZone:NULL]; \
            accessorMethodName##Instance = [accessorMethodName##Instance init]; \
            method_exchangeImplementations(\
            class_getClassMethod([accessorMethodName##Instance class], @selector(accessorMethodName)),\
            class_getClassMethod([accessorMethodName##Instance class], @selector(cwl_lockless_##accessorMethodName)));\
            method_exchangeImplementations(\
            class_getInstanceMethod([accessorMethodName##Instance class], @selector(init)),\
            class_getInstanceMethod([accessorMethodName##Instance class], @selector(cwl_onlyInitOnce)));\
        } \
    } \
    \
    return accessorMethodName##Instance; \
} \
\
+ (classname *)cwl_lockless_##accessorMethodName \
{ \
    return accessorMethodName##Instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
    return [self accessorMethodName]; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return self; \
} \
- (id)cwl_onlyInitOnce \
{ \
    return self;\
} \
\
CWL_SYNTHESIZE_SINGLETON_RETAIN_METHODS

#define VZ_DECLARE_SINGLETON_FOR_CLASS(classname) CWL_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(classname, shared##classname)
#define VZ_SYNTHESIZE_SINGLETON_FOR_CLASS(classname) CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(classname, shared##classname)
