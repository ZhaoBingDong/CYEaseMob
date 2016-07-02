//
//  DTShowHudView.h
//  Cinderella
//
//  Created by ng on 15/9/7.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShareView;
/**
 *  弹出分享视图的 view
 */
@interface DTShowHudView : NSObject
/**
 *  实例化一个 DTShowHudView
 *
 *  @return  返回一个实例
 */
+ (instancetype)shareHudView;

/**
 *  展示分享视图
 *
 *  @param data     data
 *  @param success  成功
 */
+ (void)showShareViewWithContents:(NSArray*)data successBlock:(void(^)(NSInteger index))success showInView:(UIView*)view;
/**
 *  隐藏分享视图
 */
+ (void)hiddenShareView;

/**
 *  canShowShareView
 */
@property(nonatomic,assign)BOOL canShowShareView;

/// 分享的视图
@property(nonatomic,strong)ShareView  *shareView;

@end
