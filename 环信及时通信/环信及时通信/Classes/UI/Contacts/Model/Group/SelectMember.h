//
//  SelectMember.h
//  环信及时通信
//
//  Created by dabing on 15/10/8.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  选择联系人
 */
@interface SelectMember : NSObject
/**
 *  icon
 */
@property(nonatomic,copy)NSString *icon;
/**
 *  title
 */
@property(nonatomic,copy)NSString *title;
/**
 *  isSelected
 */
@property(nonatomic,assign,getter=isSelect)BOOL select;
/**
 *  isInBlackList
 */
@property(nonatomic,assign,getter=inBlacklist)BOOL isInBlackList;


@end
