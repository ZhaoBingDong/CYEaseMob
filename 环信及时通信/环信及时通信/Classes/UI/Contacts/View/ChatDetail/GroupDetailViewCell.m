//
//  GroupDetailViewCell.m
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "GroupDetailViewCell.h"
#import "GroupDetailModel.h"
#import "ChatDetailCollectionView.h"
@implementation GroupDetailViewCell


/**
 *  实例化一个 GroupDetailViewCell
 *
 *  @param tableView tableView
 *
 *  @return  返回一个 Cell
 */
+(instancetype)registDetailViewCellWithUItableView:(UITableView*)tableView
{
    static NSString *cellID = @"Cell";
    GroupDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[GroupDetailViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    return cell;
}

/**
 *  传模型
 *
 *  @param detail    详情的模型
 *  @param indexPath  indexPath
 */
- (void)setupCellContent:(GroupDetailModel*)detail indexPath:(NSIndexPath*)indexPath
{
    [self.contentView removeAllSubviews];
    // 第一行没有点击效果
    if (indexPath.row==0) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // 选择群成员的 View
    if (detail.style == DetailCellCollectionView) {
        ChatDetailCollectionView *collection = [[ChatDetailCollectionView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 150)];
        collection.isOwer                    = NO;
        if ([[CMManager sharedCMManager].userInfo.username isEqualToString:detail.ower]) {
            collection.isOwer                = YES;
        }
        collection.members                   = detail.members;
        [self.contentView addSubview:collection];
        self.memberViews                     = collection;
    }else if (detail.style == DetailCellSubTitle){
        // 有子标题的 cell
        self.textLabel.text         = detail.title;
        UILabel *subTitleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH-20-200, 0, 200, 44)];
        subTitleLabel.text          = detail.subTitle;
        subTitleLabel.textColor     = [UIColor lightGrayColor];
        subTitleLabel.font          = [UIFont systemFontOfSize:15];
        subTitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:subTitleLabel];
    }else if (detail.style == DetailCellArrow){
        // 有跳转箭头的 cell
        self.textLabel.text         = detail.title;
        self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    
}

@end
