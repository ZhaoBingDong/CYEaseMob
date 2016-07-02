//
//  MHTabbarController.m
//  环信及时通信
//
//  Created by dabing on 15/10/6.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "MHTabbarController.h"
#import "ChatViewController.h"
#import "ContactsViewController.h"
#import "SettingViewController.h"
#import "BaseNavigationController.h"
@interface MHTabbarController ()

@end

@implementation MHTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     //添加子控制器
    [self addChildViewControllers];
    
}

/**
 *  添加各个模块的子控制器
 */
- (void)addChildViewControllers
{
    
    self.tabBar.backgroundImage = [[UIImage imageNamed:@"tabbarBackground"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    self.tabBar.selectionIndicatorImage = [[UIImage imageNamed:@"tabbarSelectBg"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    
    /// 主页
    ChatViewController *homeVC = [[ChatViewController alloc] init];
    BaseNavigationController *homeNav = [[BaseNavigationController alloc] initWithRootViewController:homeVC];
    homeVC.tabBarItem.title = @"会话";
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_chatsHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_act"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.title       = @"会话";
    // 厨师
    ContactsViewController *chefVC = [[ContactsViewController alloc] init];
    BaseNavigationController *chefNav = [[BaseNavigationController alloc] initWithRootViewController:chefVC];
    chefVC.tabBarItem.title  = @"通讯录";
    chefVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_contactsHL.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    chefVC.title       = @"通讯录";
    
    // 订单
    SettingViewController *orderVC = [[SettingViewController alloc] init];
    BaseNavigationController *orderNav = [[BaseNavigationController alloc] initWithRootViewController:orderVC];
    orderVC.tabBarItem.title  = @"设置";
    orderVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_settingHL.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    orderVC.title       = @"设置";
    
    // 设置文字不同状态下是颜色
    
    [self setTabBarItem:homeVC.tabBarItem forState:UIControlStateNormal];
    [self setTabBarItem:homeVC.tabBarItem forState:UIControlStateSelected];
    [self setTabBarItem:orderVC.tabBarItem forState:UIControlStateNormal];
    [self setTabBarItem:orderVC.tabBarItem forState:UIControlStateSelected];
    [self setTabBarItem:chefVC.tabBarItem forState:UIControlStateNormal];
    [self setTabBarItem:chefVC.tabBarItem forState:UIControlStateSelected];
    // 添加控制器到 tabbar
    
    [self addChildViewController:homeNav];
    [self addChildViewController:chefNav];
    [self addChildViewController:orderNav];
    
    self.selectedIndex = 0;

    
}

/**
 *  设置 item 的普通状态和点击状态的文字颜色
 *
 *  @param tabBarItem  ite
 *  @param state       选择状态
 */
- (void)setTabBarItem:(UITabBarItem *)tabBarItem forState:(UIControlState)state
{
    if (state==UIControlStateNormal) {
        [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateNormal];
    }else{
        [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName :DEF_TABBAR_COLOR} forState:UIControlStateSelected];
    }
}
@end
