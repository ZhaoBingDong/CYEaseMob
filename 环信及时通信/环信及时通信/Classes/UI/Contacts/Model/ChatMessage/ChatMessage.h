//
//  ChatMessage.h
//  环信及时通信
//
//  Created by dabing on 15/10/10.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChatMessageBodies;
/**
 *  聊天消息的模型 主体消息
 */
@interface ChatMessage : NSObject

/**
 *  from
 */
@property(nonatomic,copy)NSString *from;

/**
 *  ChatMessageBodies
 */
@property(nonatomic,strong)ChatMessageBodies *messagebodies;

/**
 *  to
 */
@property(nonatomic,copy)NSString *to;

/*!
 @property
 @brief 消息ID
 */
@property (nonatomic, copy) NSString *messageId;
/*!
 @property
 @brief 消息发送或接收的时间
 */
@property (nonatomic,copy) NSString *timestamp;
/*!
 @property
 @brief 消息是否已读
 */
@property (nonatomic) BOOL isRead;
/**
 *  是否回执
 */
@property (nonatomic) BOOL isReadAcked;
/*!
 @property
 @brief 消息所属的对话对象的chatter
 */
@property (nonatomic, strong) NSString *conversationChatter;
/*!
 @property
 @brief 群聊消息里的发送者用户名
 */
@property (nonatomic, copy) NSString *groupSenderName;

//@brief 消息发送状态
//
@property (nonatomic) MessageDeliveryState deliveryState;

/*!
 @property
 @brief 是否是匿名消息
 */
@property (nonatomic) BOOL isAnonymous;



/**
 *  给 ChatMessae 赋值
 *
 */
+ (instancetype)getChatMessage:(EMMessage*)message;

@end
