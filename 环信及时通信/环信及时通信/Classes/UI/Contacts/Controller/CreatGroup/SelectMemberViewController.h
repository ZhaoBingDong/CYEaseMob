//
//  SelectMemberViewController.h
//  环信及时通信
//
//  Created by dabing on 15/10/8.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  选择成员
 */
@interface SelectMemberViewController : UIViewController
- (void)sureBtnClick:(UIButton *)sender;
/**
 *  tableView
 */
@property (strong, nonatomic)UITableView *tableView;
/**
 *  dataArr
 */
@property(nonatomic,strong)NSMutableArray *dataArr;

@property (strong, nonatomic)  UIView *bottomView;

/**
 *  emStyle
 */
@property(nonatomic,assign)EMGroupStyle style;

/**
 *  groupName
 */
@property(nonatomic,copy)NSString *groupName;

/**
 *  groupIntroduce
 */
@property(nonatomic,copy)NSString *groupIntroduce;

/**
 *  拼接联系人的数组
 */
- (NSArray*)appendContact;

/**
 *  groupID
 */
@property(nonatomic,copy)NSString *groupId;

/**
 *  members
 */
@property(nonatomic,strong)NSArray *members;



@end
