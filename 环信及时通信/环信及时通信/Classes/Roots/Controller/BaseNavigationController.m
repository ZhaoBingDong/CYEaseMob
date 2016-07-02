//
//  BaseNavigationController.m
//  PerfectProject
//
//  Created by dabing on 15/9/22.
//  Copyright (c) 2015年 M.H Co.,Ltd. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count>0)
    {
        UIViewController *childVC = self.viewControllers[0];
        childVC.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count==2) {
        UIViewController *childVC = self.viewControllers[0];
        childVC.hidesBottomBarWhenPushed = NO;
    }
    return [super popViewControllerAnimated:animated];
}

+ (void)initialize
{
    
    //arning 一般设置导航条背景，不会在导航控制器的子控制器里设置
    // 1.设置导航条的背题图片 --- 设置全局
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    navBar.barTintColor = DEF_TABBAR_COLOR;

    // 3.设置导航条标题的字体和颜色
    NSDictionary *titleAttr = @{
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:22]
                                };
    [navBar setTitleTextAttributes:titleAttr];
    
    //设置返回按钮的样式
    //tintColor是用于导航条的所有Item
    navBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *navItem = [UIBarButtonItem appearanceWhenContainedIn:self, nil];

    //设置Item的字体大小
    [navItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    
    
}
@end
