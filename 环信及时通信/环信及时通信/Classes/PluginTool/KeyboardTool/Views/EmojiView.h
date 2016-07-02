//
//  EmojiView.h
//  DataSource
//
//  Created by yons on 15/6/20.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmojiView;
@class EmojiViewCell;
@class KeyboardView;
@protocol EmojiViewDataSource <NSObject,UIScrollViewDelegate>

@required

/**
 *  有多少行
 *
 *  @param emojiView  emojiview
 *  @param columns   columns
 *
 *  @return  返回行数
 */
- (NSInteger)numberOfColumnsInWaterFlowView:(EmojiView *)emojiview;
/**
 *  有多少列
 *
 *  @param emojiView  emojiview
 *  @param rows      rows
 *
 *  @return  返回列数
 */

-(NSInteger)emojiView:(EmojiView*)emojiView numberOfRowsInRows:(NSInteger)rows;

/**
 *  总共有多少个表情
 *
 *  @param emojiView  emojiview
 *
 *  @return  返回表情个数
 */
-(NSInteger)numberOfItemsInEmojiView:(EmojiView*)emojiView;



// 指定indexPath位置的单元格视图
- (EmojiViewCell *)emojiView:(EmojiView *)emojiView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end

@protocol EmojiViewDelegate <NSObject,UIScrollViewDelegate>

@optional

/**
 *  选择了第几行第几个表情
 *
 *  @param emojiView 表情 view
 *  @param indexPath indexPath
 */
-(void)emojiView:(EmojiView *)emojiView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

/**
 *  每个表情图片的高度
 *
 *  @param emojiView  emojiview
 *  @param indexPath indexPath
 *
 *  @return 返回一个高度
 */
-(CGFloat)emojiView:(EmojiView *)emojiView heigthForRowAtIndexPath:(NSIndexPath*)indexPath;

/**
 *  每个表情图片的宽度
 *
 *  @param emojiView  emojiview
 *  @param indexPath indexPath
 *
 *  @return 返回一个宽度
 */
-(CGFloat)emojiView:(EmojiView *)emojiView widthForRowAtIndexPath:(NSIndexPath*)indexPath;
/**
 *  点击了删除表情的按钮
 *
 *  @param emojiView        表情键盘
 *  @param attributedString 表情
 */
- (void)emojiView:(EmojiView *)emojiView deleteTextByRange:(NSRange)range;

@end
/**
 *  表情视图
 */
@interface EmojiView : UIScrollView
/**
 *  datasource
 */
@property(nonatomic,assign)id<EmojiViewDataSource>dataSource;

/**
 *  delegate
 */
@property(nonatomic,assign)id<EmojiViewDelegate>mydelegate;

/**
 *  刷新数据源
 */
-(void)reloadDatas;

/**
 *  展示
 */
-(void)showWithKeyboard:(KeyboardView*)emojiView;
/**
 *  隐藏
 */
-(void)hiddenWithKeyboard:(KeyboardView*)emojiView;

/**
 *  selfView
 */
@property(nonatomic,strong)UIView  *selfView;
/**
 *  分页控件
 */
@property(nonatomic,strong)UIPageControl  *pageControl;

/**
 *  textField
 */
@property(nonatomic,strong)UITextField  *textField;

/**
 *  删掉按钮
 */
@property(nonatomic,strong)UIButton  *deleteBtn;


@end
