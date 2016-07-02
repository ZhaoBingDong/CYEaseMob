//
//  UserChatLocationCell.m
//  环信及时通信
//
//  Created by yons on 15/10/13.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "UserChatLocationCell.h"
#import "ChatBaseFrame.h"
#import "ChatMessage.h"
#import "ChatMessageBodies.h"
@implementation UserChatLocationCell
/// 注册一个 Cell 并设置可重用标示符
+ (instancetype)registUserChatLocationCell:(UITableView*)tableView
{
    static NSString *cellID = @"UserChatLocationCell";
    UserChatLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UserChatLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        //chat_location_preview.png
    }
    return cell;
}
/// 构造方法初始化一个 Cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 位置信息的图片
        self.loactionImageView = [[UIImageView alloc] init];
        [self.loactionImageView setImage:[UIImage imageNamed:@"chat_location_preview.png"]];
        [self.bubbleView addSubview:self.loactionImageView];
        // 文字
        self.addressLabel      = [[UILabel alloc] init];
        self.addressLabel.font  = FOUN_SIZE(12);
        self.addressLabel.textAlignment = NSTextAlignmentCenter;
        self.addressLabel.textColor = [UIColor whiteColor];
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self.loactionImageView addSubview:self.addressLabel];
    }
    return self;
}
// 重写set方法
- (void)setCellFrame:(ChatBaseFrame *)cellFrame
{
    [super setCellFrame:cellFrame];
    // 图片的 frame
    [self.loactionImageView setFrame:cellFrame.locationViewFrame];
    // 文字 label
    self.addressLabel.text      = cellFrame.chatMessage.messagebodies.address;
    [self.addressLabel setFrame:cellFrame.addressLabelFrame];
}
@end
