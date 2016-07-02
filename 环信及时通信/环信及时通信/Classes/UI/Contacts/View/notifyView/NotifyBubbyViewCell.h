//
//  NotifyBubbyViewCell.h
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotifyModel;
/**
 *  加好友申请的 cell
 */
@interface NotifyBubbyViewCell : UITableViewCell
/**
 *  notify
 */
@property(nonatomic,strong)NotifyModel *notify;
/**
 *  昵称的 label
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  子标题
 */
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
/**
 *  拒绝的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sender;
/**
 *  同意的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *agree;
/**
 *  图标 区分加群或者加好友
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/**
 *  badgeView
 */
@property (weak, nonatomic) IBOutlet UIView *badgeView;


@end
