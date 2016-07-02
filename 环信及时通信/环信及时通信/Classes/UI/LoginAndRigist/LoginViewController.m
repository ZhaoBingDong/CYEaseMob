//
//  LoginViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/6.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
@interface LoginViewController ()
<UITextFieldDelegate>
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    // 模拟注册用户
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(registUser) userInfo:nil repeats:YES];
//    [timer fire];
//    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)registUser
{
    NSString *userName = [NSString stringWithFormat:@"%lD",arc4random()%100000000000+111111111];
    NSString *password = @"111111";
    self.accoutTF.text = userName;
    self.passwordTF.text = password;
    
    [self regist:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 账号
    NSString *accout   = [HMFileManager readUserDataForKey:DEF_USERACCOUT];
    NSString *password = [HMFileManager readUserDataForKey:DEF_PASSWORD];// 密码
    self.accoutTF.text   = accout;  // 账号
    self.passwordTF.text = password;// 密码
    // 账号密码不为空 就自动登录账号
    BOOL autoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (!autoLogin) {
        
        [HMFileManager removeUserDataForkey:DEF_PASSWORD];
    }
}
/// 注册的接口
- (IBAction)regist:(id)sender {
    
    if ([self isEmpty]) {
        SHOW_ALERT(@"账号或者密码为空!");
        return;
    }
    [MBProgressHUD showHUD];
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.accoutTF.text password:self.passwordTF.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        [MBProgressHUD dissmiss];
        if (!error) {
//            SHOW_ALERT(@"注册成功");
            return ;
        }
        SHOW_ALERT(error.description);
    } onQueue:nil];
}
/// 登陆的接口
- (IBAction)login:(id)sender {
  
    if ([self isEmpty]) {
        SHOW_ALERT(@"账号或者密码为空!");
        return;
    }
    [self.view endEditing:YES];
    // 请求登录的接口
    [self requestLoginAPI];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/**
 *  请求登录的接口
 */
- (void)requestLoginAPI
{
    [MBProgressHUD showHUD];
    /// 调用登陆的方法
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.accoutTF.text password:self.passwordTF.text completion:^(NSDictionary *loginInfo, EMError *error) {
        [MBProgressHUD dissmiss];
        if (!error && loginInfo) {
            NSString *accout   = self.accoutTF.text;  // 账号
            NSString *password = self.passwordTF.text;// 密码
            [HMFileManager saveUserData:accout forKey:DEF_USERACCOUT];
            [HMFileManager saveUserData:password forKey:DEF_PASSWORD];
            // 封装用户资料的模型
            [CMManager saveUserInfo:loginInfo];
            [AppDelegate didLogin];
            return ;
        }
        SHOW_ALERT(error.description);
    } onQueue:nil];
}
//判断账号和密码是否为空
- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *username = self.accoutTF.text;
    NSString *password = self.passwordTF.text;
    if (username.length == 0 || password.length == 0) {
        ret = YES;
    }
    return ret;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.integerValue>600) {
        return NO;
    }
    
    return YES;
}
@end
