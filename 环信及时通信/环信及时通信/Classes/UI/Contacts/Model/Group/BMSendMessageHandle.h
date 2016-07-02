//
//  BMSendMessageHandle.h
//  环信及时通信
//
//  Created by dabing on 15/10/12.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChatGroupRoomViewController;
@class Placemark;
/**
 *  发送消息的管理者
 */
@interface BMSendMessageHandle : NSObject
/**
 *  发送普通文本的消息
 *
 *  @param text 文本
 */
+ (void)sendTextMessageWithText:(NSString*)text atViewController:(ChatGroupRoomViewController*)viewController;
/**
 *  收到了别人发的消息的接口
 *
 *  @param message 收到的消息对象
 */
+ (void)didReceiveMessage:(EMMessage *)message atViewController:(ChatGroupRoomViewController*)viewController;
/**
 *  请求当前群组的信息
 *
 *  @param viewController 当前的控制器
 */
+ (void)requestGroupInfoAtViewController:(ChatGroupRoomViewController*)viewController;
/**
 *  请求历史消息的记录
 *
 *  @param messageId        最后一条消息的 id
 *  @param viewController   当前的控制器
 */
+ (void)getHistroyMessageByMessageId:(NSString*)messageId atViewController:(ChatGroupRoomViewController*)viewController;
/**
 *  发送图片消息
 *
 *  @param image           image
 *  @param viewController  当前的控制器
 */
+(void)sendImageMessage:(UIImage*)image atViewController:(ChatGroupRoomViewController*)viewController;
/**
 *  发送位置消息
 *
 *  @param place           保存位置信息的类
 *  @param viewController  当前的控制器
 */
+ (void)sendLoactionMessage:(Placemark*)place atViewController:(ChatGroupRoomViewController*)viewController;
/**
 *  发送语音消息
 *
 *  @param filePath        录制的语音的本地路径
 *  @param viewController  当前的控制器
 */
+ (void)sendVoiceMessage:(NSString*)filePath duration:(NSInteger)duration atViewController:(ChatGroupRoomViewController*)viewController;


@end
