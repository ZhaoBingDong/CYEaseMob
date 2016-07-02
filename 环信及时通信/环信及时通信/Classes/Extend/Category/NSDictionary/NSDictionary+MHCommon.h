//
//  NSDictionary+MHCommon.h
//  MHProject
//
//  Created by MengHuan on 15/5/14.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MHCommon)


#pragma mark - 代替原NSDictionary里的objectForKey方法
/**
 *  代替原NSDictionary里的objectForKey方法
 *
 *  @param aKey 传入key
 *
 *  @return 返回key对应的value
 */
- (id)objectForMHKey:(id)aKey;

@end
