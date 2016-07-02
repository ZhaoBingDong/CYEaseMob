//
//  UserChatLocationCell.h
//  环信及时通信
//
//  Created by yons on 15/10/13.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "UserChatBaseViewCell.h"
/// 用户定位消息的 cell
@interface UserChatLocationCell : UserChatBaseViewCell

/**
 *  addressLabel
 */
@property(nonatomic,strong)UILabel *addressLabel;

/**
 *  locationImageView
 */
@property(nonatomic,strong)UIImageView  *loactionImageView;

/// 注册一个 Cell 并设置可重用标示符
+ (instancetype)registUserChatLocationCell:(UITableView*)tableView;

@end
