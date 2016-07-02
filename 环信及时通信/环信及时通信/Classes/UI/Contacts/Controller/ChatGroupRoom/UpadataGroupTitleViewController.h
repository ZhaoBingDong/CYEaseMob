//
//  UpadataGroupTitleViewController.h
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  群组昵称修改
 */
@interface UpadataGroupTitleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
/**
 *  groupId
 */
@property(nonatomic,copy)NSString *groupId;

/**
 *  nickname
 */
@property(nonatomic,copy)NSString *nickname;

@end
