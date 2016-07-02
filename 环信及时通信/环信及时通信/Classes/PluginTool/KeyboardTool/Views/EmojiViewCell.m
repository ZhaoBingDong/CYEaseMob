//
//  EmojiViewCell.m
//  DataSource
//
//  Created by yons on 15/6/20.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "EmojiViewCell.h"

@implementation EmojiViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
