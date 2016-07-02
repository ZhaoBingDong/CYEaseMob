//
//  NSObject+MHBlock.m
//  MHProject
//
//  Created by MengHuan on 15/6/5.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "NSObject+MHBlock.h"
#import <objc/runtime.h>

@implementation NSObject (MHBlock)


#pragma mark - 在主线程中执行block1，在后台完成后执行block2
+ (void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block1();
        dispatch_async(dispatch_get_main_queue(),^{
            block2();
        });
    });
}

- (void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block1();
        dispatch_async(dispatch_get_main_queue(),^{
            block2();
        });
    });
}


#pragma mark - 使用 MHObject 传递参数(retain)
const char MHObjectStoreKey;

- (void)setMHObject:(id)obj
{
    objc_setAssociatedObject(self, &MHObjectStoreKey, obj, OBJC_ASSOCIATION_RETAIN);
}

- (id)getMHObject
{
    return objc_getAssociatedObject(self, &MHObjectStoreKey);
}


#pragma mark - 默认block回调
const char MHObjectEventHandlerDictionary;

- (void)handlerDefaultEventWithBlock:(id)block
{
    [self handlerEventWithBlock:block withIdentifier:@"mhDefaultEventHandler"];
}

- (id)blockForDefaultEvent
{
    return [self blockForEventWithIdentifier:@"mhDefaultEventHandler"];
}

- (void)handlerEventWithBlock:(id)block withIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    NSMutableDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&MHObjectEventHandlerDictionary);
    if(eventHandlerDictionary == nil)
    {
        eventHandlerDictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &MHObjectEventHandlerDictionary, eventHandlerDictionary, OBJC_ASSOCIATION_RETAIN);
    }
    
    [eventHandlerDictionary setObject:block forKey:identifier];
}

- (id)blockForEventWithIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    NSDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&MHObjectEventHandlerDictionary);
    if(eventHandlerDictionary == nil) return nil;
    return [eventHandlerDictionary objectForKey:identifier];
}


#pragma mark - 数据的回传
const char MHObjectSingleObjectDictionary;

- (void)receiveObject:(void(^)(id object))sendObject
{
    [self receiveObject:sendObject withIdentifier:@"MHObjectSingleObjectDictionary"];
}

- (void)sendObject:(id)object
{
    [self sendObject:object withIdentifier:@"MHObjectSingleObjectDictionary"];
}

- (void)receiveObject:(void(^)(id object))sendObject withIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    NSMutableDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&MHObjectSingleObjectDictionary);
    if(eventHandlerDictionary == nil)
    {
        eventHandlerDictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &MHObjectSingleObjectDictionary, eventHandlerDictionary, OBJC_ASSOCIATION_RETAIN);
    }
    
    [eventHandlerDictionary setObject:sendObject forKey:identifier];
}

- (void)sendObject:(id)object withIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    
    NSDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&MHObjectSingleObjectDictionary);
    if(eventHandlerDictionary == nil)
        return;
    
    void(^block)(id object) = [eventHandlerDictionary objectForKey:identifier];
    block(object);
}


#pragma mark - 给UITableViewCell的数据存储计算过的行高的，防止重复计算
const char MHRowHeightKey;

- (float)mhRowHeight
{
    NSNumber *number = objc_getAssociatedObject(self,&MHRowHeightKey);
    if(number == nil) return -1;
    return [number floatValue];
}

- (void)setMHRowHeight:(float)height
{
    objc_setAssociatedObject(self,
                             &MHRowHeightKey,
                             [NSNumber numberWithFloat:height],
                             OBJC_ASSOCIATION_RETAIN);
}

@end
