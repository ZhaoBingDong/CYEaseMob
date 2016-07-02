//
//  NSObject+MHBlock.h
//  MHProject
//
//  Created by MengHuan on 15/6/5.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MHBlock)

// 在主线程中执行block1，在后台完成后执行block2
+ (void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2;
- (void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2;


// 使用 MHObject 传递参数(retain)
- (void)setMHObject:(id)obj;
- (id)getMHObject;


// 默认block回调 key:mhDefaultEventHandler
- (void)handlerDefaultEventWithBlock:(id)block;
- (id)blockForDefaultEvent;

// 设置一个block作为回调
- (void)handlerEventWithBlock:(id)block withIdentifier:(NSString *)identifier;
- (id)blockForEventWithIdentifier:(NSString *)identifier;


// 数据的回传
// send object
// handle block with default identifier is @"MHObjectSingleObjectDictionary".
- (void)receiveObject:(void(^)(id object))sendObject;
- (void)sendObject:(id)object;

// tag can't be nil
- (void)receiveObject:(void(^)(id object))sendObject withIdentifier:(NSString *)identifier;
- (void)sendObject:(id)object withIdentifier:(NSString *)identifier;


// 给UITableViewCell的数据存储计算过的行高的，防止重复计算
// 类似于setMHObject，不过这个意义更明确
- (float)mhRowHeight;
- (void)setMHRowHeight:(float)height;

@end
