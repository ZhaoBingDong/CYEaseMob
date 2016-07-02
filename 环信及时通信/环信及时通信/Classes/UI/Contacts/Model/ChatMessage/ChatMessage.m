//
//  ChatMessage.m
//  环信及时通信
//
//  Created by dabing on 15/10/10.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ChatMessage.h"
#import "ChatMessageBodies.h"
@implementation ChatMessage
/**
 *  给 ChatMessae 赋值
 *
 */
+ (instancetype)getChatMessage:(EMMessage*)msg
{
    ChatMessage *chatMessage        = [ChatMessage new];
    chatMessage.from                = msg.from;
    chatMessage.to                  = msg.to;
    chatMessage.groupSenderName     = msg.groupSenderName;
    chatMessage.messageId           = msg.messageId;
    chatMessage.isRead              = msg.isRead;
    chatMessage.isReadAcked         = msg.isReadAcked;
    chatMessage.conversationChatter = msg.groupSenderName;
    chatMessage.deliveryState       = msg.deliveryState;
    chatMessage.isAnonymous         = msg.isAnonymous;
    chatMessage.conversationChatter = msg.conversationChatter;
    chatMessage.timestamp           = [[CMManager sharedCMManager] changeTimestampToCommonTime:msg.timestamp format:@"MM-dd HH:mm:ss"];
    chatMessage.messagebodies       = [self getMessageBodiesWith:msg.messageBodies];
    return chatMessage;
}

/**
 *  获取聊天的消息体
 *
 *  @param messagebodies 聊天消息体
 *
 *  @return 返回一个数组
 */
+(ChatMessageBodies*)getMessageBodiesWith:(NSArray*)messagebodies
{
    ChatMessageBodies *bodies = [ChatMessageBodies new];
    for (NSObject *obj in messagebodies)
    {
//        NSLog(@"-----%@",obj.class);
        if ([obj isKindOfClass:[EMTextMessageBody class]])
        {
            // 构造文本消息内容
            EMTextMessageBody *textBody = (EMTextMessageBody*)obj;
            bodies.text                 = textBody.text;
            bodies.messageBodyType      = textBody.messageBodyType;
        }else if ([obj isKindOfClass:[EMImageMessageBody class]])
        {
            // 构造图片消息内容
            EMImageMessageBody *body    = (EMImageMessageBody*)obj;
            bodies.remotePath           = body.remotePath;
            bodies.localPath            = body.localPath;
            bodies.localWidth           = body.size.width;
            bodies.localHeight          = body.size.height;
            bodies.thumbnailRemotePath  = body.thumbnailRemotePath;
            bodies.thumbnailLocalPath   = body.thumbnailLocalPath;
            bodies.thumbnailWidth       = body.thumbnailSize.width;
            bodies.thumbnailHeight      = body.thumbnailSize.height;
            bodies.messageBodyType      = body.messageBodyType;
        }else if ([obj isKindOfClass:[EMLocationMessageBody class]])
        {
            // 构造位置消息的模型
            EMLocationMessageBody *body     = (EMLocationMessageBody *)obj;
            bodies.longitude                = body.longitude;
            bodies.latitude                 = body.latitude;
            bodies.address                  = body.address;
            bodies.messageBodyType          = body.messageBodyType;
        }else if ([obj isKindOfClass:[EMVoiceMessageBody class]])
        {
            // 构造声音消息的模型
            EMVoiceMessageBody *body        = (EMVoiceMessageBody *)obj;
            bodies.voicelocalPath           = body.remotePath;
            bodies.voicelocalPath           = body.localPath;
            bodies.secretKey                = body.secretKey;
            bodies.fileLength               = body.fileLength;
            bodies.duration                 = body.duration;
            bodies.messageBodyType          = body.messageBodyType;
        }
    }
    return bodies;
}

@end
