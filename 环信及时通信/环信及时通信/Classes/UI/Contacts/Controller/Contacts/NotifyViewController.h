//
//  NotifyViewController.h
//  环信及时通信
//
//  Created by dabing on 15/10/7.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  通知和消息
 */
@interface NotifyViewController : UIViewController
/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  dataArray
 */
@property(nonatomic,strong)NSMutableArray *dataArray;



@end
