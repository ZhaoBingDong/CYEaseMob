//
//  KeyboardView.h
//  DataSource
//
//  Created by yons on 15/6/21.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmojiView;
@class EmojiModel;
@class MyButton;
@class KeyboardView;

@protocol KeyboardViewDelegate <NSObject>

@optional

/**
 *  发送文字了
 *
 *  @param message 要发送的消息
 */
- (void)keyboardViewDidSendMessage:(NSString *)message;
/**
 *  发送图片
 */
- (void)keyboardViewDidSendImageView;
/**
 *  开始录音
 */
- (void)keyboardViewDidStartRecord:(UIButton*)button;
/**
 *  结束录音
 */
- (void)keyboardViewDidEndRocord:(NSURL*)filePath;
/**
 *  键盘位置发送改变
 *
 *  @param topPositon 键盘顶部的位置
 */
- (void)keyboardViewChangePosition:(CGFloat)topPositon;

@end

/**
 *  即时通信聊天常用键盘
 */
@interface KeyboardView : UIView
/**
 *  textField
 */
@property (nonatomic,strong)UITextField  *textField;

/**
 *  voiceBtn
 */
@property(nonatomic,strong)MyButton  *voiceBtn;

/**
 *  faceBtn
 */
@property(nonatomic,strong)MyButton  *faceBtn;

/**
 *  addBtn
 */
@property(nonatomic,strong)MyButton  *addBtn;

/**
 *  voiceView
 */
@property(nonatomic,strong)UIView  *voiceView;
/**
 *  emojiView
 */
@property(nonatomic,strong)EmojiView  *emojiView;
/**
 *  父视图
 */
@property(nonatomic,strong)UIView  *selfSuperView;
/**
 *  array
 */
@property(nonatomic,strong)NSArray  *array;
/**
 *  所有子控件失去第一相应
 */
-(void)allSubviewsResignFirstResponder;
/**
 *  mydelegate
 */
@property(nonatomic,unsafe_unretained)id<KeyboardViewDelegate>mydelegate;
/**
 *  recordView
 */
@property (nonatomic,strong)UIButton  *recordBtn;

@end
