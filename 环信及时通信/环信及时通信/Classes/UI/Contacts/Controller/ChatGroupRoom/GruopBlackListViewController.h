//
//  GruopBlackListViewController.h
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  群组黑名单
 */
@interface GruopBlackListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableVeiw;
/**
 *  dataArray
 */
@property(nonatomic,strong)NSMutableArray *dataArray;

/**
 *  groupId
 */
@property(nonatomic,copy)NSString *groupId;

/**
 *  members
 */
@property(nonatomic,strong)NSArray *members;


@end
