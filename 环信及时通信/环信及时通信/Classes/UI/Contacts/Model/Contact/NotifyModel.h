//
//  NotifyModel.h
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  好友加群申请的通知
 */
@interface NotifyModel : NSObject
/**
 *  icon
 */
@property(nonatomic,copy)NSString *icon;
/**
 *  username
 */
@property(nonatomic,copy)NSString *username;
/**
 *  reason
 */
@property(nonatomic,copy)NSString *reason;
/**
 *  type
 */
@property(nonatomic,copy)NSString *type;
/**
 *  groupId
 */
@property(nonatomic,copy)NSString *groupId;

/**
 *  groupName
 */
@property(nonatomic,copy)NSString *groupName;

/**
 *  isRead
 */
@property(nonatomic,assign)BOOL isRead;

/**
 *  isArrow
 */
@property(nonatomic,copy)NSString *isArrow;


@end
