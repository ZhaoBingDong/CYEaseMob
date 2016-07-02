//
//  UserChatTextViewCell.m
//  环信及时通信
//
//  Created by dabing on 15/10/10.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "UserChatTextViewCell.h"
#import "ChatBaseFrame.h"
#import "ChatMessage.h"
#import "ChatMessageBodies.h"
@implementation UserChatTextViewCell
/// 注册一个 Cell 并设置可重用标示符 
+ (instancetype)registUserChatTextViewCell:(UITableView*)tableView
{
    static NSString *cellID = @"Cell";
    UserChatTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UserChatTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
/// 构造方法初始化一个 Cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //  文字的 label
        self.messageLabel                   = [[UILabel alloc] init];
        self.messageLabel.font              = [UIFont systemFontOfSize:15];
        self.messageLabel.textColor         = [UIColor blackColor];
        self.messageLabel.numberOfLines     = 0;
        [self.bubbleView addSubview:self.messageLabel];
    }
    return self;
}
// 重写set方法
- (void)setCellFrame:(ChatBaseFrame *)cellFrame
{
    [super setCellFrame:cellFrame];
    // 消息的模型
    NSString *message       = cellFrame.chatMessage.messagebodies.text;
    // 将普通的消息文本转化成图文混排的富文本
    NSAttributedString *string = [HMDatabaseTool getAttributedString:message];
    // 消息
    [self.messageLabel setAttributedText:string];
    // 根据不同消息发送者 设置label的对齐方式
    NSTextAlignment textAlignment = cellFrame.isSelf == YES ? NSTextAlignmentRight : NSTextAlignmentLeft;
    [self.messageLabel setTextAlignment:textAlignment];
    [self.messageLabel setFrame:cellFrame.contentLabelFrame];
    
}

@end
