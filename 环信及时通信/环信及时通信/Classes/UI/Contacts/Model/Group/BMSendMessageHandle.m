//
//  BMSendMessageHandle.m
//  环信及时通信
//
//  Created by dabing on 15/10/12.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "BMSendMessageHandle.h"
#import "ChatMessage.h"
#import "ChatBaseFrame.h"
#import "ChatGroupRoomViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Placemark.h"
#define WeakChatRoomVC      __weak  ChatGroupRoomViewController *roomVC = viewController

@implementation BMSendMessageHandle

#pragma mark - 发送普通文本消息
/**
 *  发送普通文本的消息
 *
 *  @param text 文本
 */
+ (void)sendTextMessageWithText:(NSString*)message atViewController:(ChatGroupRoomViewController*)viewController
{
    WeakChatRoomVC;
    EMChatText *txtChat = [[EMChatText alloc] initWithText:message];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    // 生成message
    EMMessage *sendMessage = [[EMMessage alloc] initWithReceiver:roomVC.groupID bodies:@[body]];
    sendMessage.messageType = eMessageTypeGroupChat; // 设置为群组消息
    [self sendMessageRequest:sendMessage atViewController:roomVC];
}
# pragma mark - 收到了别人发送过来的消息
/**
 *  收到了别人发的消息的接口
 *
 *  @param message 收到的消息对象
 */
+ (void)didReceiveMessage:(EMMessage *)message atViewController:(ChatGroupRoomViewController*)viewController
{
    WeakChatRoomVC;
    roomVC.needScrollToBottom     = YES;
    [[SoundManager sharedSoundManager] musicPlayByName:@"msgTritone.caf"];
    ChatMessage   *chatMsg  = [ChatMessage getChatMessage:message];
    ChatBaseFrame *frame    = [ChatBaseFrame getChatFrameWithChatMessage:chatMsg];
    [roomVC.chatArray addObject:frame];
    [roomVC reloadTableView];
}
#pragma mark - 获取群组消息
/**
 *  获取群组的信息
 *
 *  @param viewController 群组聊天的控制器
 */
+ (void)requestGroupInfoAtViewController:(ChatGroupRoomViewController *)viewController
{
    [MBProgressHUD showHUD];
    WeakChatRoomVC;
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:viewController.groupID completion:^(EMGroup *group, EMError *error) {
        [MBProgressHUD dissmiss];
        if (!error) {
            roomVC.emGroup = group;
        }else
        {
            [MBProgressHUD showError:error.description toView:roomVC.view];
        }
    } onQueue:nil];
}
#pragma mark - 获取历史聊天记录
/**
 *  拉去历史记录的接口
 *
 *  @param messageId      最后一条消息的 id
 *  @param viewController  聊天的控制器
 */
+ (void)getHistroyMessageByMessageId:(NSString *)messageId atViewController:(ChatGroupRoomViewController *)viewController
{
    WeakChatRoomVC;
    [viewController.activityView setHidden:NO];
    viewController.lastMessageId = messageId;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *messages = [roomVC.conversation loadNumbersOfMessages:5 withMessageId:messageId];
        NSMutableArray *tempArr = [NSMutableArray array];
        // 便利数组东西
        for (EMMessage *msg  in messages)
        {
            // 获取聊天消息的模型
            ChatMessage *message     = [ChatMessage getChatMessage:msg];
            // 根据消息模型传给 frame 模型计算 cell 高度或者里边子控件的 frame
            ChatBaseFrame *baseFrame = [ChatBaseFrame getChatFrameWithChatMessage:message];
            [tempArr addObject:baseFrame];
        }
        // 把获取的历史记录插入到历史记录的数组最前边
        if (tempArr.count>0) {
            [roomVC.historyArray insertObjects:tempArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tempArr.count)]];
        }
        // 然后把历史记录数组插入到聊天大数组的最前边
        if (roomVC.historyArray.count>0)
        {
            [roomVC.chatArray insertObjects:roomVC.historyArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, roomVC.historyArray.count)]];
        }
        [roomVC reloadTableView];
        [roomVC.activityView setHidden:YES];
    });
}
#pragma mark - 发送图片消息
/**
 *  发送图片消息
 *
 *  @param image           image
 *  @param viewController  当前的控制器
 */
+(void)sendImageMessage:(UIImage*)image atViewController:(ChatGroupRoomViewController*)viewController
{
    WeakChatRoomVC;
    EMChatImage *imgChat = [[EMChatImage alloc] initWithUIImage:image displayName:@"displayName"];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithChatObject:imgChat];
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:viewController.groupID bodies:@[body]];
//    message.messageType = eMessageTypeChat; // 设置为单聊消息
    message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
    //message.messageType = eConversationTypeChatRoom;// 设置为聊天室消息
    [self sendMessageRequest:message atViewController:roomVC];
}
#pragma mark - 发送位置消息
/**
 *  发送位置消息
 *
 *  @param place           保存位置信息的类
 *  @param viewController  当前的控制器
 */
+ (void)sendLoactionMessage:(Placemark*)place atViewController:(ChatGroupRoomViewController*)viewController
{
    CLLocationCoordinate2D coordinate   = place.location;
    EMChatLocation *locChat = [[EMChatLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude address:place.FormattedAddressLines];
    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithChatObject:locChat];
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:viewController.groupID bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    [self sendMessageRequest:message atViewController:viewController];
}

/// 将拼好的消息模型传给环信 调用发消息的公共接口
+ (void)sendMessageRequest:(EMMessage*)messages atViewController:(ChatGroupRoomViewController*)viewController
{
    __weak ChatGroupRoomViewController *roomVC = viewController;
    TYPEWEAKSELF;
    [[EaseMob sharedInstance].chatManager asyncSendMessage:messages progress:nil prepare:nil onQueue:nil completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            [weakSelf sendMessageSuccess:message atViewController:roomVC];
        }
    } onQueue:nil];
}
#pragma mark - 发送消息成功的回调
/**
 *  发送消息成功后要做的的事情
 *
 *  @param message        消息
 *  @param viewController 当前的控制器
 */
+ (void)sendMessageSuccess:(EMMessage*)message atViewController:(ChatGroupRoomViewController*)viewController
{
    WeakChatRoomVC;
    roomVC.needScrollToBottom     = YES;
    [[SoundManager sharedSoundManager]musicPlayByName:@"sendSuccess.caf"];
    ChatMessage *chatMsg            = [ChatMessage getChatMessage:message];
    ChatBaseFrame *frame            = [ChatBaseFrame getChatFrameWithChatMessage:chatMsg];
    [roomVC.chatArray addObject:frame];
    [roomVC reloadTableView];
}

/**
 *  发送语音消息
 *
 *  @param filePath        录制的语音的本地路径
 *  @param viewController  当前的控制器
 */
+ (void)sendVoiceMessage:(NSString*)filePath duration:(NSInteger)duration atViewController:(ChatGroupRoomViewController*)viewController
{
    EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:filePath displayName:@"audio"];
    voice.duration = 60-duration;
    if (voice.duration == 0) {
        voice.duration  = 60;
    }
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:viewController.groupID bodies:@[body]];
    message.messageType = eConversationTypeGroupChat; // 设置为单聊消息
    //message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
    //message.messageType = eConversationTypeChatRoom;// 设置为聊天室消息
    [self sendMessageRequest:message atViewController:viewController];
}
@end
