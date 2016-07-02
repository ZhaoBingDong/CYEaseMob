//
//  CMManager.m
//  BMProject
//
//  Created by MengHuan on 15/4/19.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "CMManager.h"
#import "UserInfo.h"
#import "NotifyModel.h"

@interface CMManager()<EMChatManagerDelegate>
@end
@implementation CMManager

singleton_for_class(CMManager)



#pragma mark - 判断字符串是否为空
- (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    // 去掉前后空格，判断length是否为0
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    
    if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"null"]) {
        return YES;
    }
    
    // 不为空
    return NO;
}

#pragma mark - 判断是否为真实手机号码
- (BOOL)checkInputMobile:(NSString *)_text
{
    //
    NSString *MOBILE    = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CM        = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378]|7[7])\\d)\\d{7}$";   // 包含电信4G 177号段
    NSString *CU        = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT        = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    //
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:_text];
    BOOL res2 = [regextestcm evaluateWithObject:_text];
    BOOL res3 = [regextestcu evaluateWithObject:_text];
    BOOL res4 = [regextestct evaluateWithObject:_text];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - 判断email格式是否正确
- (BOOL)isAvailableEmail:(NSString *)emailString
{
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    //先把NSString转换为小写
    NSString *lowerString       = emailString.lowercaseString;
    
    return [regExPredicate evaluateWithObject:lowerString] ;
}

#pragma mark - 姓名验证
- (BOOL)isValidateName:(NSString *)name
{
    // 只含有汉字、数字、字母、下划线不能以下划线开头和结尾
    NSString *userNameRegex = @"^(?!_)(?!.*?_$)[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:name];
}

#pragma mark - 时间戳转时间格式
- (NSString *)changeTimestampToCommonTime:(long long)time format:(NSString *)format;
{
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    //设置时区
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    return [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
}


#pragma mark - 时间格式转时间戳
- (long)changeCommonTimeToTimestamp:(NSString *)time format:(NSString *)format
{
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    //设置时区
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    return (long)[[formatter dateFromString:time] timeIntervalSince1970];
}


#pragma mark - 获取当前使用语言
- (NSString *)currentLanguage
{
    NSString *opinion   = [NSLocale preferredLanguages][0];
    NSDictionary *dict  = @{
                            @"chs"      : @"chs",
                            @"cht"      : @"cht",
                            @"jp"       : @"jp",
                            @"kr"       : @"kr",
                            @"zh-Hans"  : @"chs",
                            @"zh-Hant"  : @"cht",
                            @"ja"       : @"jp",
                            @"ko"       : @"kr",
                            };
    
    // 不满足以上整合的语种，则全部默认为 en 英文
    return dict[opinion] ? dict[opinion] : @"en";
}


#pragma mark - 打印出项目工程里自定义字体名
- (void)printCustomFontName
{
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames )
    {
        printf( "Family: %s \n", [familyName UTF8String]);
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames )
        {
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
}
/// 获取当前的用户
+ (UserInfo *)currentUser
{
    UserInfo *user  = [HMFileManager getObjectByFileName:@"User"];
    return user;
}
/**
 *  存储用户资料的模型
 *
 *  @param dict 字典
 */
+(void)saveUserInfo:(NSDictionary*)dict
{
    UserInfo *user = [UserInfo objectWithKeyValues:dict];
    // 存储用户资料
    [HMFileManager saveObject:user byFileName:@"User"];
    [self sharedCMManager].userInfo = user;
}
/**
 *  懒加载通知消息的数组
 */
- (NSMutableArray *)notices
{
    if (!_notices) {
        _notices = [NSMutableArray array];
    }
    return _notices;
}

/**
 *  开始监听通知
 */
- (void)startObserverNotily
{
    // 监听通知事件
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}
/**
 *  已经发送过加群的申请了
 *
 *  @param username 用户名称
 *
 *  @return 返回 result
 */
- (BOOL)hasSendJoinGroupRequest:(NSString*)username groupId:(NSString*)groupId
{
    BOOL flag = NO;
    for (NotifyModel *noti in self.notices)
    {
        if ([noti.username isEqualToString:username]&&[noti.groupId isEqualToString:groupId]) {
            flag = YES;
        }
    }
    return flag;
}
#pragma mark - EMChatManagerDelegate
/**
 *  收到了其他人要求加群的消息
 *
 *  @param groupId   群组的 id
 *  @param groupname 群组的名称
 *  @param username  加群人的名字
 *  @param reason    加群的原因
 *  @param error     错误信息
 */
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    BOOL flag = [self hasSendJoinGroupRequest:username groupId:groupId];
    if (flag ==YES ) return;
    NotifyModel *model = [NotifyModel new];
    model.groupId      = groupId;
    model.type         = @"1";
    model.reason       = reason;
    model.groupName    = groupname;
    model.username     = username;
    model.isRead       = NO;
    model.isArrow      = @"0";
    [self.notices insertObject:model atIndex:0];
    // 通过回调告诉外边接收到了新的加群通知
    if (self.didReceiveApplyToJoinGroup) {
        self.didReceiveApplyToJoinGroup(self.notices);
    }
}
/**
 *  退出群组的通知
 *
 *  @param group       退出的群组
 *  @param leaveReason 退出群组的原因
 */
- (void)group:(EMGroup *)group didLeaveWithReason:(EMGroupLeaveReason)leaveReason
{
    
    
}

/*!
 @method
 @brief 加入公开群组后的回调
 @param group 群组对象
 @param error 错误信息
 */
- (void)didJoinPublicGroup:(EMGroup *)group
                     error:(EMError *)error
{
    
    
    
}
/**
 *  存储所有的通知消息
 */
+(void)saveNotifys
{
    NSMutableArray *notices =[CMManager sharedCMManager].notices;
    [HMFileManager saveObject:notices byFileName:@"notices"];
}
/**
 *  判断是不是用户自身
 *
 *  @param userName 用户名
 *
 *  @return 返回结果
 */
+ (BOOL)isUserSelf:(NSString *)userName
{
    BOOL    isSelf          =  NO;
    if ([userName isEqualToString:[CMManager sharedCMManager].userInfo.username]) {
        isSelf              = YES;
    }
    return isSelf;
}
@end
