//
//  LoginViewController.h
//  环信及时通信
//
//  Created by dabing on 15/10/6.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 登陆的控制器啊
@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *accoutTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
- (IBAction)regist:(id)sender;
- (IBAction)login:(id)sender;

@end
