//
//  AppDelegate.m
//  环信及时通信
//
//  Created by dabing on 15/10/6.
//  Copyright © 2015年 大兵布莱恩特. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"
#import "LoginViewController.h"
#import "MHTabbarController.h"
#import "AppDelegate+EaseMob.h"

@interface AppDelegate ()<EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    /// 初始化 Window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    // 判断是否登录
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (isAutoLogin) {
        // 自动登录状态下可以直接进主界面
        [AppDelegate addTabbarController];
    }else
    {
        /// 添加登陆的控制器
        [AppDelegate addLoginViewController];
    }
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    // 是否开启声音提醒
    NSString *isOpen             = [HMFileManager readUserDataForKey:[NSString stringWithFormat:@"%d",0]];
    if (isOpen&&[isOpen isEqualToString:@"1"])
    {
        [[SoundManager sharedSoundManager]setCanPlaySound:YES];
    }else if (!isOpen){
        [[SoundManager sharedSoundManager]setCanPlaySound:YES];
    }
    return YES;
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }

}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];

}

// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [CMManager saveNotifys];
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [CMManager saveNotifys];
    BOOL autoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (!autoLogin) {
        
        [HMFileManager removeUserDataForkey:DEF_PASSWORD];
    }
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


/// 已经登陆了
+(void)didLogin
{
    // 设置自动登录
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
    //获取数据库中数据
    [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
    //获取群组列表
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];

    // 翻转动画
    UIViewController *loginVC=  [[[UIApplication sharedApplication]delegate]window].rootViewController;
    [UIView transitionWithView:loginVC.view duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
    }completion:^(BOOL finished) {
        [loginVC.view removeFromSuperview];
        [self addTabbarController];
    }];
}
/**
 *  添加 tabbarController 自动登录后加载 tabbarControlelr
 */
+ (void)addTabbarController
{
    MHTabbarController *tabbar = [[MHTabbarController alloc] init];
    [[[UIApplication sharedApplication]delegate]window].rootViewController = tabbar;
}
/**
 *  退出登录
 */
+ (void)didLoginOut
{
    [self addLoginViewController];
}
/**
 *  添加登录的控制器
 */
+ (void)addLoginViewController
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [[[UIApplication sharedApplication]delegate]window].rootViewController = nav;
    // 退出登录后免登录将关闭
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
}
@end
