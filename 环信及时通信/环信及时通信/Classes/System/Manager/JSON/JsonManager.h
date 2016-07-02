//
//  JsonManager.h
//  BMProject
//
//  Created by MengHuan on 15/4/19.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonManager : NSObject

/**
 *  json解析
 *
 *  @param string数据源
 *
 *  @return 解析后的数据
 */
+ (id)JSONValue:(NSString *)string;



+ (id)objectWithData:(NSData *)data;
+ (NSData *)dataWithObject:(id)dict;

+ (id)dictWithJson:(NSString *)json;
+ (NSString *)jsonWithDict:(id)dict;

@end
