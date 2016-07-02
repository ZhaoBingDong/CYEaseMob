//
//  AddFriendViewController.h
//  环信及时通信
//
//  Created by dabing on 15/10/7.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  添加好友
 */
@interface AddFriendViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

/**
 *  添加好友的模型
 */
@interface AddFriendModel : NSObject
/**
 *  姓名
 */
@property(nonatomic,copy)NSString *name;

@end
