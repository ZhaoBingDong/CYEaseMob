//
//  ChatGroupRoomViewController.h
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Placemark;
/**
 *  进入群聊的房间
 */
@interface ChatGroupRoomViewController : UIViewController
/**
 *  群组ID
 */
@property(nonatomic,copy)NSString *groupID;
/**
 *  表视图
 */
@property (strong, nonatomic)  UITableView *tableView;
/**
 *  会话管理者
 */
@property (strong, nonatomic) EMConversation *conversation;
/**
 *  自定义键盘工具
 */
@property(nonatomic,strong)KeyboardView *keyboardView;

/**
 *  emGroup
 */
@property(nonatomic,strong)EMGroup *emGroup;
/**
 *  历史记录的数组
 */
@property(nonatomic,strong)NSMutableArray *historyArray;
/**
 *  所有聊天是数组
 */
@property(nonatomic,strong)NSMutableArray *chatArray;
/**
 *  是否回滚到底部
 */
@property(nonatomic,assign)BOOL    needScrollToBottom;
/**
 *  是否刷新数据
 */
@property(nonatomic,assign)BOOL     needRefresh;

/**
 *  lastMessagID
 */
@property(nonatomic,copy)NSString  *lastMessageId;;

/**
 *  活动指示器
 */
@property(nonatomic,strong)UIView   *activityView;

/**
 *    _timer;
 */
@property (nonatomic,strong)NSTimer  *timer;


/**
 *  刷新表
 */
- (void)reloadTableView;

/**
 *  发送了位置信息
 */
- (void)sendLocationMessageBy:(Placemark*)place;


@end
