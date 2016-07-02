//
//  CMManager.h
//  BMProject
//
//  Created by MengHuan on 15/4/19.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

/**
 *  常用方法管理器
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SingletonTemplate.h"   // 单例模板
#import "UserInfo.h"
@class UserInfo;
@class ChatMessageBodies;
@interface CMManager : NSObject

singleton_for_header(CMManager)



#pragma mark - 判断字符串是否为空
/**
 *  判断字符串是否为空
 *
 *  @param string 要判断的字符串
 *
 *  @return 返回YES为空，NO为不空
 */
- (BOOL)isBlankString:(NSString *)string;


#pragma mark - 判断是否为真实手机号码
/**
 *  判断是否为真实手机号码
 *
 *  @param mobile 手机号
 *
 *  @return 返回YES为真实手机号码，NO为否
 */
- (BOOL)checkInputMobile:(NSString *)_text;


#pragma mark - 判断email格式是否正确
/**
 *  判断email格式是否正确
 *
 *  @param emailString 邮箱
 *
 *  @return 返回YES为Email格式正确，NO为否
 */
- (BOOL)isAvailableEmail:(NSString *)emailString;


#pragma mark - 姓名验证
/**
 *  姓名验证
 *
 *  @param name 姓名
 *
 *  @return 返回YES为姓名规格正确，NO为否
 */
- (BOOL)isValidateName:(NSString *)name;


#pragma mark - 时间戳转时间格式
/**
 *  时间戳转时间格式
 *
 *  @param timestamp    传入时间戳
 *  @param format       格式,如"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 普通时间
 */
- (NSString *)changeTimestampToCommonTime:(long long)time format:(NSString *)format;


#pragma mark - 时间格式转时间戳
/**
 *  时间格式转时间戳
 *
 *  @param time   普通时间
 *  @param format 格式,如"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 时间戳
 */
- (long)changeCommonTimeToTimestamp:(NSString *)time format:(NSString *)format;

/// 获取当前的用户资料
+(UserInfo*)currentUser;
/**
 *  存储用户资料的模型
 *
 *  @param dict 字典
 */
+(void)saveUserInfo:(NSDictionary*)dict;

/**
 *  userInfo
 */
@property(nonatomic,strong)UserInfo *userInfo;

/**
 *  notices
 */
@property(nonatomic,strong)NSMutableArray *notices;
/**
 *  收到了申请加群消息的 block
 */
@property(nonatomic,copy) void(^didReceiveApplyToJoinGroup)(NSMutableArray *notices);

/**
 *  开始监听通知
 */
- (void)startObserverNotily;
/**
 *  存储所有的通知消息
 */
+(void)saveNotifys;

/**
 *  判断是不是用户自己
 *
 *  @param userName 用户名
 *
 *  @return 返回结果
 */
+ (BOOL)isUserSelf:(NSString*)userName;

@end
