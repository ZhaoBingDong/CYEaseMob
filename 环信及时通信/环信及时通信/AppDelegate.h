//
//  AppDelegate.h
//  环信及时通信
//
//  Created by dabing on 15/10/6.
//  Copyright © 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate>
{
    EMConnectionState _connectionState;
}
@property (strong, nonatomic) UIWindow *window;

/**
 *  已经登陆
 */
+(void)didLogin;

/**
 *  退出登录
 */
+ (void)didLoginOut;

@end

