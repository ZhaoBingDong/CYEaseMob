//
//  ChatViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/6.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ChatViewController.h"
#import "DTShowProgressView.h"
@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSString *username = [HMFileManager readUserDataForKey:DEF_USERACCOUT];
    NSString *userPassword = [HMFileManager readUserDataForKey:DEF_PASSWORD];
    if (!username&&!userPassword) return;
    [DTShowProgressView showInView:self.view maskType:DTShowTaskTypeCoverView withStatus:@"正在自动登录中..."];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:userPassword completion:^(NSDictionary *loginInfo, EMError *error)
     {
         [DTShowProgressView dissmiss];
         if (!error)
         {
             // 开始监听申请和通知
             [[CMManager sharedCMManager]startObserverNotily];
             // 存储用户资料
             [CMManager saveUserInfo:loginInfo];
             // 设置自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
         }
     } onQueue:nil];
}
/**
 *  视图将要出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


@end
