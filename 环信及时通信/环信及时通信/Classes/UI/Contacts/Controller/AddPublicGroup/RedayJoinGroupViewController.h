//
//  RedayJoinGroupViewController.h
//  环信及时通信
//
//  Created by dabing on 15/10/8.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  准备加群的控制器
 */
@interface RedayJoinGroupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupOwer;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
- (IBAction)button:(UIButton *)sender;
/**
 *  groupId
 */
@property(nonatomic,copy)NSString *groupID;

@end
