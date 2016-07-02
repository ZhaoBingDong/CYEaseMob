//
//  ChatListTableViewCell.h
//  环信及时通信
//
//  Created by dabing on 15/10/7.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  好友列表的 cell
 */
@interface ChatListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label; // label
@property (weak, nonatomic) IBOutlet UIImageView *iconView; // 头像

@end
