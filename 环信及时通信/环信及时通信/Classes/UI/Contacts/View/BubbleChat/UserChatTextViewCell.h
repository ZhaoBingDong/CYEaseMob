//
//  UserChatTextViewCell.h
//  环信及时通信
//
//  Created by dabing on 15/10/10.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "UserChatBaseViewCell.h"

/**
 *  用户文本的气泡
 */
@interface UserChatTextViewCell : UserChatBaseViewCell

/**
 *  textLabel
 */
@property(nonatomic,strong)UILabel *messageLabel;


/// 注册一个 Cell 并设置可重用标示符
+ (instancetype)registUserChatTextViewCell:(UITableView*)tableView;


@end
