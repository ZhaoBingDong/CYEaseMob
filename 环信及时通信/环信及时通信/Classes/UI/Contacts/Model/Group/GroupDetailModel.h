//
//  GroupDetailModel.h
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

typedef NS_ENUM(NSInteger, DetailCellType) {
    /**
     *  collctionView
     */
    DetailCellCollectionView,
    /**
     *  subTitle
     */
    DetailCellSubTitle,
    /**
     *  arrow
     */
    DetailCellArrow,
    /**
     *  actionView
     */
    DetailCellActionView
};

#import <Foundation/Foundation.h>
/**
 *  群组详情的模型
 */
@interface GroupDetailModel : NSObject
/**
 *  title
 */
@property(nonatomic,copy)NSString *title;
/**
 *  subTitle
 */
@property(nonatomic,copy)NSString *subTitle;
/**
 *  members
 */
@property(nonatomic,strong)NSArray *members;
/**
 *  style
 */
@property(nonatomic,assign)enum DetailCellType style;

/**
 *  showClass
 */
@property(nonatomic,assign)Class showClass;

/**
 *  operation
 */
@property(nonatomic,copy) void (^operation)();

/**
 *  ower
 */
@property(nonatomic,copy)NSString *ower;

@end
