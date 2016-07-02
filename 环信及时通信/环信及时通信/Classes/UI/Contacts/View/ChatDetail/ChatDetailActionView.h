//
//  ChatDetailActionView.h
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatDetailActionView;
@protocol ChatDetailActionViewDelegate <NSObject>

@optional

/**
 *  选择了群组黑名单
 */
- (void)chatDetailActionViewDidSelctGroupBlackList;
/**
 *  清除聊天记录
 */
- (void)chatDetailActionViewDidSelctCleanAllChatRecord;
/**
 *  解散群组
 */
- (void)chatDetailActionViewDidSelctCloseChatGourp;

@end
/**
 *  底部解散群组的 view
 */
@interface ChatDetailActionView : UIView
/**
 *  titleLabel
 */
@property(nonatomic,strong)UILabel *titleLabel;
/**
 *  arrowImage
 */
@property(nonatomic,strong)UIImageView *arrowImageView;
/**
 *  clearChatRocord
 */
@property(nonatomic,strong)UIButton *cleanChatRocord;
/**
 *  closeGourpBtn
 */
@property(nonatomic,strong)UIButton *closeGroupBtn;
/**
 *  delegate
 */
@property(nonatomic,assign)id<ChatDetailActionViewDelegate>delegate;
/**
 *  是否为群主
 */
@property(nonatomic,assign,getter=isOwer)BOOL ower;

/**
 *  cell
 */
@property(nonatomic,strong)UIView *cell;

@end
