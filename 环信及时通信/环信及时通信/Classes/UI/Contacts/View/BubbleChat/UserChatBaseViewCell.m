//
//  UserChatBaseViewCell.m
//  环信及时通信
//
//  Created by yons on 15/10/11.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "UserChatBaseViewCell.h"
#import "ChatBaseFrame.h"
#import "ChatMessage.h"

@implementation UserChatBaseViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 日期的 label
        self.dataLabel                      = [[UILabel alloc] init];
        self.dataLabel.textColor            = [UIColor grayColor];
        self.dataLabel.textAlignment        = DEF_TextAlignmentCenter;
        self.dataLabel.font                 = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.dataLabel];
        // 昵称的 label
        self.nicknameLabel                  = [[UILabel alloc] init];
        self.nicknameLabel.textAlignment    = DEF_TextAlignmentCenter;
        self.nicknameLabel.font             = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.nicknameLabel];
        // 头像的 icon
        self.iconView                       = [[UIImageView alloc] init];
        [self.iconView setImage:[UIImage imageNamed:@"chatListCellHead.png"]];
        [self.contentView addSubview:self.iconView];
        // 气泡
        self.bubbleView                     = [[UIImageView alloc] init];
        [self.bubbleView setUserInteractionEnabled:YES];
        [self.contentView addSubview:self.bubbleView];
    }
    return self;
}
/// set 方法给 cellFrame 模型赋值
- (void)setCellFrame:(ChatBaseFrame *)cellFrame
{
    _cellFrame      = cellFrame;
    // 日期
    self.dataLabel.text = cellFrame.chatMessage.timestamp;
    self.dataLabel.frame = cellFrame.dateLabelFrame;
    // 昵称
    [self.nicknameLabel setText:cellFrame.chatMessage.from];
    [self.nicknameLabel setFrame:cellFrame.nicknameFrame];
    // 头像
    [self.iconView setFrame:cellFrame.iconViewFrame];
    // 气泡
    [self.bubbleView setFrame:cellFrame.bubbleViewFrame];
    UIImage *bubbleImage    = cellFrame.bubbleimage;
    [self.bubbleView setImage:bubbleImage];
}
@end
