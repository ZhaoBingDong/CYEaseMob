//
//  GroupListViewController.h
//  环信及时通信
//
//  Created by dabing on 15/10/7.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  群组
 */
@interface GroupListViewController : UIViewController
/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  dataArr
 */
@property(nonatomic,strong)NSMutableArray *dataArr;

@end
