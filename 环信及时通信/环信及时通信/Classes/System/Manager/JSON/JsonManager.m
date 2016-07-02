//
//  JsonManager.m
//  BMProject
//
//  Created by MengHuan on 15/4/19.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "JsonManager.h"

@implementation JsonManager

+ (id)JSONValue:(NSString *)string
{
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}




// data数据转换成字典或数组
+ (id)objectWithData:(NSData *)data
{
    //iOS 5以上，NSJSONSerialization类可用
    if (!data) {
        NSLog(@"JsonManager objectWithData data is nil");
        
        return nil;
    }
    
    NSError *error  = nil;
    id result       = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error) {
        NSLog(@"JsonManager objectWithData error: %@", error);
    }
    
    return result;
}

// 传入字典或者array 转换成data
+ (NSData *)dataWithObject:(id)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]
        && ![dict isKindOfClass:[NSArray class]]
        ) {
        NSLog(@"dataFromDict dict error");
        
        return nil;
    }
    
    //使用系统版本
    NSError *error  = nil;
    id result       = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"jsonManager data error->%@", error);
    }
    
    return result;
}

// json字符串转字典
+ (id)dictWithJson:(NSString *)json
{
    if (![json isKindOfClass:[NSString class]]) {
        NSLog(@"dictFromJson json error");
        
        return nil;
    }
    
    // 所有的数据判断都放到上面的方法，这里直接调用上面的方法即可
    return [JsonManager objectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]];
}

// 字典转json字符串
+ (NSString *)jsonWithDict:(id)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]
        && ![dict isKindOfClass:[NSArray class]]
        ) {
        NSLog(@"jsonFromDict dict error");
        
        return nil;
    }
    
    // 所有的数据判断都放到上面的方法，这里直接调用上面的方法即可
    NSData *data = [JsonManager dataWithObject:dict];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
