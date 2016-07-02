//
//  UserInfo.h
//  环信及时通信
//
//  Created by dabing on 15/10/6.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
/// 用户信息的模型
@interface UserInfo : NSObject

/// 最后登陆的时间
@property(nonatomic,copy)NSString *lastLoginTime;
/// jid
@property(nonatomic,copy)NSString *jid;
///passwrod
@property(nonatomic,copy)NSString *password;
/// resource
@property(nonatomic,copy)NSString *resource;
/// token
@property(nonatomic,copy)NSString *token;
/// username
@property(nonatomic,copy)NSString *username;


@end
