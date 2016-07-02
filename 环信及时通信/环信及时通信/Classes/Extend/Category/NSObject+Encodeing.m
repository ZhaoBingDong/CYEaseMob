//
//  NSObject+Encodeing.m
//  HMExtents
//
//  Created by yons on 15/7/8.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "NSObject+Encodeing.h"
#import <objc/runtime.h>
@implementation NSObject (Encodeing)


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self encoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self dencoder:aDecoder];
    
    return self;
}

// 反归档
- (void)dencoder:(NSCoder *)decoder
{
    unsigned count = 0;
    
    Ivar  *ivars = class_copyIvarList([self class], &count);
    
    for (int i =0; i<count; i++)
    {
        Ivar  var = ivars[i];
        
        const char *name = ivar_getName(var);
        
        NSString *key = [NSString stringWithFormat:@"%s",name];
        
        id value = [decoder decodeObjectForKey:key];

        [self setValue:value forKey:key];
    }
    
}

/// 归档
-(void)encoder:(NSCoder*)encoder
{
    unsigned count = 0;
    
    Ivar  *ivars = class_copyIvarList([self class], &count);
    
    for (int i =0; i<count; i++)
    {
        Ivar  var = ivars[i];
        
        const char *name = ivar_getName(var);
        
        NSString *key = [NSString stringWithFormat:@"%s",name];
        
        id value = [self valueForKeyPath:key];
        
        [encoder encodeObject:value forKey:key];
        
    }
    
}

@end
