//
//  ChatGroupModel.h
//  环信及时通信
//
//  Created by dabing on 15/10/8.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  聊天模型的数组
 */
@interface ChatGroupModel : NSObject
/**
 *  icon
 */
@property(nonatomic,copy)NSString *icon;

/**
 *  title
 */
@property(nonatomic,copy)NSString *title;

/**
 *  showClass
 */
@property(nonatomic,assign)Class showClass;

/**
 *  groupId
 */
@property(nonatomic,copy)NSString *groupId;

/**
 *  emGroup
 */
@property(nonatomic,strong)EMGroup *emGruop;

@end
