//
//  ChatDetailCollectionView.h
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatDetailCollectionView;

@protocol ChatDetailCollectionViewDelegate <NSObject>

@optional

/**
 *  选择了 item 用来添加群成员
 */
- (void)ChatDetailCollectionViewDidSelectItemForAddFriend;

@end
/**
 *  顶部选择群成员的 view
 */
@interface ChatDetailCollectionView : UIView
/**
 *  members
 */
@property(nonatomic,strong)NSArray *members;

/**
 *  delegate
 */
@property(nonatomic,assign)id<ChatDetailCollectionViewDelegate>delegate;
/**
 *  是否为群主
 */
@property (nonatomic,assign)BOOL isOwer;
@end
