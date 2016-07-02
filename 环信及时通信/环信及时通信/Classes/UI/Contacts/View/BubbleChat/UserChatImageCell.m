//
//  UserChatImageCell.m
//  环信及时通信
//
//  Created by yons on 15/10/11.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "UserChatImageCell.h"
#import "ChatImageFrame.h"
#import "ChatMessage.h"
#import "ChatMessageBodies.h"
@implementation UserChatImageCell
+ (instancetype)registUserChatImageMessageViewCell:(UITableView*)tableView
{
    static NSString *cellID = @"ImageCell";
    UserChatImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UserChatImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.receiveImageView = [[UIImageView alloc] init];
        [self.bubbleView addSubview:self.receiveImageView];
        
        // 添加点击的手势
        [self.bubbleView setUserInteractionEnabled:YES];
        [self.bubbleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookImage:)]];
    }
    
    return self;
}

- (void)setCellFrame:(ChatBaseFrame *)cellFrame
{
    [super setCellFrame:cellFrame];
    
    self.receiveImageView.frame = cellFrame.receiveImageFrame;
    // 环信加载图片当没有的时候加载网络的图片 当你程序退出时加载你本地的图片 所以需要用 thumbnailLocalPath;
    NSString *imagePath = cellFrame.chatMessage.messagebodies.remotePath;
    NSURL  *imageUrl = [NSURL URLWithString:imagePath];
    if (!imagePath)
    {
        imagePath       =  cellFrame.chatMessage.messagebodies.localPath;
        imageUrl        = [NSURL fileURLWithPath:imagePath];
    }
    // 设置图片
    [self.receiveImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"imageDownloadFail.png"]];
    // 给点击的气泡设置索引
    self.bubbleView.tag     = cellFrame.imageIndex;
}
/**
 *  点击查看图片
 *
 *  @param image  image
 */
- (void)lookImage:(UITapGestureRecognizer*)tapView
{
    UIView *view = (UIView*)tapView.view;
    if ([self.delete respondsToSelector:@selector(userChatImageCell:didSelectImageAtIndexPath:)])
    {
        [self.delete userChatImageCell:self didSelectImageAtIndexPath:view.tag];
    }
}
@end
