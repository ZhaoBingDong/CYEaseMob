//
//  UserChatCellProtocol.h
//  环信及时通信
//
//  Created by dabing on 15/10/12.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserChatImageCell;
@class UserChatVoiceCell;
/**
 *  聊天的 cell 的协议
 */
@protocol UserChatCellProtocol <NSObject>

@optional

/**
 *  选择了图片
 *
 *  @param cell   cell
 *  @param index  idnex
 */
- (void)userChatImageCell:(UserChatImageCell*)cell didSelectImageAtIndexPath:(NSInteger)index;
/**
 *  选择了语音
 *
 *  @param cell   cell
 *  @param index  idnex
 */
- (void)userChatVoiceCell:(UserChatVoiceCell*)cell didSelectImageAtIndexPath:(NSInteger)index;
/**
 *  语音播放完毕
 *
 *  @param cell   cell
 *  @param index  idnex
 */
- (void)userChatVoiceCell:(UserChatVoiceCell *)cell didFinishedPlayVoiceAtIndexPath:(NSInteger)index;

@end
