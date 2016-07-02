//
//  ChatBaseFrame.h
//  环信及时通信
//
//  Created by dabing on 15/10/10.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ChatMessage;
/**
 *  聊天消息 frame 基类
 */
@interface ChatBaseFrame : NSObject
/**
 *  dataFrame
 */
@property(nonatomic,assign)CGRect dateLabelFrame;

/**
 *  iconViewFrame
 */
@property(nonatomic,assign)CGRect iconViewFrame;

/**
 *  bubuleViewFrame
 */
@property(nonatomic,assign)CGRect bubbleViewFrame;

/**
 *  contentLabelFrame
 */
@property(nonatomic,assign)CGRect contentLabelFrame;

/**
 *  chatMessage
 */
@property(nonatomic,strong)ChatMessage *chatMessage;

/**
 *  nicknameFrame
 */
@property(nonatomic,assign)CGRect nicknameFrame;
/**
 *  receiveImageFrame
 */
@property(nonatomic,assign)CGRect receiveImageFrame;
/**
 *  locationLabelFrame
 */
@property(nonatomic,assign)CGRect  locationViewFrame;
/**
 *  addressLabelFrame
 */
@property(nonatomic,assign)CGRect  addressLabelFrame;

/**
 *  duritionLabelFrame
 */
@property(nonatomic,assign)CGRect  duritionLabelFrame;

/**
 *  voiceIconFrame
 */
@property(nonatomic,assign)CGRect  voiceIconFrame;

/**
 *  image
 */
@property(nonatomic,strong)UIImage *bubbleimage;

/**
 *  cellHeight
 */
@property(nonatomic,assign)CGFloat  cellHeight;
/**
 *  isSelf
 */
@property(nonatomic,assign)BOOL  isSelf;

/**
 *  imageIndex
 */
@property(nonatomic,assign)NSInteger imageIndex;

/**
 *  voiceIconImage
 */
@property(nonatomic,copy)UIImage *voiceIconImage;

/**
 *  canPlsyVoice
 */
@property(nonatomic,assign)BOOL  canPlayVoice;

/**
 *  类方法创建一个 frame 模型
 *
 *  @param message 传一个消息模型进来
 *
 *  @return 返回一个 baseFrame 的模型
 */
+ (instancetype)getChatFrameWithChatMessage:(ChatMessage*)message;

@end
