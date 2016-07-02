//
//  ShareView.h
//  Cinderella
//
//  Created by ng on 15/9/7.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 数量最大不能超过5
#define KShowViewItemCountInRow  8
#define KShowViewDuritionTime  0.0001
@class ShareView;

@protocol ShareViewDelegate <NSObject>

@required

/**
 *  将要显示
 */
- (void)shareViewWillShowInView;
/**
 *  即将消失
 */
- (void)shareViewWillHiddenInView;

@end

@interface ShareView : UIView
/**
 *  cancelBtn
 */
@property (strong, nonatomic) UIButton *cancel;
/**
 *  bgView
 */
@property (strong, nonatomic) UIView *bgView;
/**
 *  coverView
 */
@property (strong, nonatomic) UIView *coverView;
/**
 *  titleLabel
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  显示
 */
- (void)showShareView:(id)params successBlock:(void(^)())success;
/**
 *  隐藏
 */
- (void)hiddenShareView;
/**
 *  delegate
 */
@property(nonatomic,weak)id<ShareViewDelegate>delegate;
/**
 *  shareContents
 */
@property (strong, nonatomic) NSArray *params;
/**
 *  success
 */
@property(nonatomic,copy) void(^success)();

@end
