//
//  ChatDetailCollectionView.m
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ChatDetailCollectionView.h"

@implementation ChatDetailCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    }
    return self;
}
/**
 *  set 方法给members 赋值
 */
- (void)setMembers:(NSArray *)members
{
    _members = members;
    // 设置界面布局
    [self resetViews];
}
/**
 *  初始化界面
 */
- (void)resetViews
{
    
    CGFloat itemWidth  = (DEF_SCREEN_WIDTH-120)/5;
    CGFloat itemHeight = itemWidth;
    // 如果群成员少于200 可以添加群成员 如果正好200 则不能添加群成员
    NSInteger itemCount  = self.members.count<=199?(self.members.count+1):200;
    if (self.isOwer == NO) {
        itemCount -=1;
    }
    CGFloat lastY      = 0.0f; // 最后一个 item 的位置来决定整个 view 的高度
    for (int i =0; i<itemCount; i++) {
   
        CGFloat itemY = 40+(itemHeight+15)*(i/5);
        CGFloat itemX = 20+(itemWidth+20)*(i%5);
        // item
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(itemX, itemY, itemWidth, itemHeight)];
        item.layer.cornerRadius  = 5;
        item.layer.masksToBounds = YES;
        [self addSubview:item];
        // 图片
        UIImage *image = nil;
        // 昵称
        NSString *name = nil;
        if (i<self.members.count) {
            name = self.members[i]; // 昵称
            UILabel *nameLabel     = [[UILabel alloc] initWithFrame:CGRectMake(0, itemHeight-20, itemWidth, 20)];
            nameLabel.text         = name;
            nameLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            nameLabel.textColor    = [UIColor whiteColor];
            nameLabel.font         = [UIFont systemFontOfSize:10];
            [item addSubview:nameLabel];
            // 图片为头像
            image =  [UIImage imageNamed:@"chatListCellHead.png"];
        }else
        {
            // 不足200人支持添加联系人
            image = [UIImage imageNamed:@"group_participant_add.png"];
            // 添加手势事件 用来添加联系人
            [item addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        }
        [item setBackgroundImage:image forState:UIControlStateNormal];
        
        lastY = itemY;
    }
    // 设置 collectionView的高度
    [self setHeight:lastY+20+itemHeight];
}
/**
 *  添加联系人
 *
 *  @param tapView 联系人
 */
- (void)addFriend:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(ChatDetailCollectionViewDidSelectItemForAddFriend)]) {
        [self.delegate ChatDetailCollectionViewDidSelectItemForAddFriend];
    }
}

- (void)setIsOwer:(BOOL)isOwer
{
    _isOwer     = isOwer;
}

@end
