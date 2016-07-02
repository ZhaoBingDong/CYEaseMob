//
//  SettingItem.h
//  环信及时通信
//
//  Created by dabing on 15/10/6.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AccessViewType) {
    /**
     *  跳转的箭头
     */
    AccessViewTypeArrow  = 0,
    /**
     *  开关
     */
    AccessViewTypeSwitch = 1
};
/**
 *  设置界面的模型
 */
@interface SettingItem : NSObject
/**
 *  标题
 */
@property(nonatomic,copy)NSString *title;

/**
 *  type
 */
@property(nonatomic,assign)AccessViewType type;

/**
 *  showVC
 */
@property(nonatomic,assign)Class showVC;
/**
 *  switchOperation
 */
@property(nonatomic,copy) void(^switchOperation)(BOOL isOpen);

/**
 *  isOpen
 */
@property(nonatomic,assign)BOOL isOpen;

@end
