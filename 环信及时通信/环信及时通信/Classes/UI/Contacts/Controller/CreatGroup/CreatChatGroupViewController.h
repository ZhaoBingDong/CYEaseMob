//
//  CreatChatGroupViewController.h
//  环信及时通信
//
//  Created by dabing on 15/10/8.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  创建群组的界面
 */
@interface CreatChatGroupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (strong,nonatomic) UILabel *placeHoderLabel;
- (IBAction)ValueChange:(UISwitch *)sender;
- (IBAction)valueChange2:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@end
