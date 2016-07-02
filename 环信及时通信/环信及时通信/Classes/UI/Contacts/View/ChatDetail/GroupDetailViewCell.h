//
//  GroupDetailViewCell.h
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupDetailModel;
@class ChatDetailCollectionView;
/**
 *  群组详情的 Cell
 */
@interface GroupDetailViewCell : UITableViewCell
/**
 *  实例化一个 GroupDetailViewCell
 *
 *  @param tableView tableView
 *
 *  @return  返回一个 Cell
 */
+(instancetype)registDetailViewCellWithUItableView:(UITableView*)tableView;
/**
 *  传模型
 *
 *  @param detail    详情的模型
 *  @param indexPath  indexPath
 */
- (void)setupCellContent:(GroupDetailModel*)detail indexPath:(NSIndexPath*)indexPath;

/**
 *  membersView
 */
@property(nonatomic,strong)ChatDetailCollectionView *memberViews;


@end
