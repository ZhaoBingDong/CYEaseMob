//
//  GroupDetailViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "GroupDetailController.h"
#import "GroupDetailModel.h"
#import "GroupDetailViewCell.h"
#import "ChatDetailCollectionView.h"
#import "ChatDetailActionView.h"
#import "UpadataGroupTitleViewController.h"
#import "GroupSettingViewController.h"
#import "GruopBlackListViewController.h"
#import "SelectMemberViewController.h"

@interface GroupDetailController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    ChatDetailCollectionViewDelegate, // 选择群成员 view 的协议
    ChatDetailActionViewDelegate , // 底部操作选项 view 的协议
    UIAlertViewDelegate
>
{
    BOOL        _isOwer; // 是否为群组
}
@end

@implementation GroupDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载数据源
    [self loadDatas];
    // 添加尾部视图
    [self addFootView];
}
/**
 *  加载数据源
 */
- (void)loadDatas
{
    TYPEWEAKSELF
    // 判断用户是否是群主
    NSString *username                  = [CMManager sharedCMManager].userInfo.username;
    _isOwer                             = NO;
    if ([username isEqualToString:self.emgroup.owner]==YES) {
        _isOwer                         = YES;
    }
    // 群成员
    GroupDetailModel *members           = [GroupDetailModel new];
    members.style                       = DetailCellCollectionView;
    members.ower                        = self.emgroup.owner;
    members.members                     = self.emgroup.occupants;
    // 群组 ID
    GroupDetailModel *groupID           = [GroupDetailModel new];
    groupID.title                       = @"群组ID";
    groupID.subTitle                    = self.emgroup.groupId;
    groupID.style                       = DetailCellSubTitle;
    // 群组人数
    GroupDetailModel *groupMemberCounts = [GroupDetailModel new];
    groupMemberCounts.title             = @"群组人数";
    groupMemberCounts.subTitle          = [NSString stringWithFormat:@"%ld/200",(long)self.emgroup.groupOccupantsCount];
    groupMemberCounts.style             = DetailCellSubTitle;
    // 群设置
    GroupDetailModel *groupSetting      = [GroupDetailModel new];
    groupSetting.title                  = @"群设置";
    groupSetting.showClass              = [GroupSettingViewController class];
    groupSetting.style                  = DetailCellArrow;
    // 修改群昵称
    GroupDetailModel *changeGroupName   = [GroupDetailModel new];
    changeGroupName.title               = @"修改群昵称";
    changeGroupName.showClass           = [UpadataGroupTitleViewController class];
    changeGroupName.style               = DetailCellArrow;
    // 退出群组
    GroupDetailModel *exitGroup         = [GroupDetailModel new];
    exitGroup.title                     = @"退出群组";
    exitGroup.showClass                 = [UpadataGroupTitleViewController class];
    exitGroup.style                     = DetailCellSubTitle;
    exitGroup.subTitle                  = @"";
    exitGroup.operation                 = ^(){
        [weakSelf quitGroupAlert];
    };
    // 将模型添加到数组里
    [self.dataArray addObject:members];
    [self.dataArray addObject:groupID];
    [self.dataArray addObject:groupMemberCounts];
    if (_isOwer == YES)
    {
        [self.dataArray addObject:groupSetting];
        [self.dataArray addObject:changeGroupName];
    }else
    {
        [self.dataArray addObject:exitGroup];
    }
    [self.tableView reloadData];
}
/**
 *  退出群组的提示
 */
- (void)quitGroupAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要退出这个群组吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退群", nil];
    alertView.tag          = 3;
    [alertView show];
}
/**
 *  退出群组的请求
 */
- (void)quitGroupRequest
{
    TYPEWEAKSELF
    [MBProgressHUD showHUD];
    // 退出群组的接口
    [[EaseMob sharedInstance].chatManager asyncLeaveGroup:self.emgroup.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
        [MBProgressHUD dissmiss];
        if (!error) {
            [MBProgressHUD showSuccess:@"退出群组成功" toView:weakSelf.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } onQueue:nil];

}
/**
 *  添加尾部视图
 */
- (void)addFootView
{
    CGFloat footViewHeight  = _isOwer == YES?200:120;
    // 有操作选项的 cell
    self.actionView = [[ChatDetailActionView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, footViewHeight)];
    self.actionView.delegate = self;
    self.actionView.ower     = _isOwer;
    self.tableView.tableFooterView = self.actionView;
}
/**
 *  懒加载数据源数组
 */
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/**
 *  视图将要出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupDetailViewCell *cell = [GroupDetailViewCell registDetailViewCellWithUItableView:tableView];
    // 传模型给 Cell 设置 cell 上的内容
    GroupDetailModel *detailModel = self.dataArray[indexPath.row];
    [cell setupCellContent:detailModel indexPath:indexPath];
    if (cell.memberViews)
    {
        cell.memberViews.delegate = self;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GroupDetailModel *detail = self.dataArray[indexPath.row];
    // 如果模型里边封装的有代码就调用模型里边的代码
    if (detail.operation) {
        detail.operation();
        return;
    }
    if (detail.style == DetailCellArrow) {
        if (indexPath.row == 3) {// 群设置
            GroupSettingViewController *setingVC = [[GroupSettingViewController alloc] init];
            setingVC.groupId                     = self.emgroup.groupId;
            [self.navigationController pushViewController:setingVC animated:YES];
        }else if (indexPath.row == 4){ // 群昵称修改
            UpadataGroupTitleViewController *updataVC = [[UpadataGroupTitleViewController alloc] init];
            updataVC.groupId                          = self.emgroup.groupId;
            updataVC.nickname                         = self.emgroup.groupSubject;
            [self.navigationController pushViewController:updataVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupDetailModel *model = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        NSArray *members = model.members;
        return [self membersViewHeight:members];
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001f;
}
/**
 *  计算群成员 view 的高度
 *
 *  @param members 根据群成员的人数
 *
 *  @return 返回一个高度
 */
- (CGFloat)membersViewHeight:(NSArray*)members
{
    CGFloat itemHeight = (DEF_SCREEN_WIDTH-120)/5; // 每个 item 的高度
    // 获取成员的个数
    NSInteger itemCount  = members.count<=199?(members.count+1):200;
    // 不是群主不能添加群成员所有要减去 + 号按钮的位置
    if (!_isOwer&&members.count<=199) {
        itemCount -=1;
    }
    CGFloat lastItemY  = 0.0f;
    for (int i =0; i<itemCount; i++)
    {
        CGFloat itemY = 40+(itemHeight+15)*(i/5);
        lastItemY     = itemY;
    }
    return lastItemY+itemHeight+20;
}
#pragma mark - ChatDetailCollectionViewDelegate
/**
 *  添加联系人进群的接口
 */
- (void)ChatDetailCollectionViewDidSelectItemForAddFriend
{
    SelectMemberViewController *selectMemberVC = [[SelectMemberViewController alloc] init];
    selectMemberVC.groupId                     = self.emgroup.groupId;
    selectMemberVC.members                     = self.emgroup.members;
    [self.navigationController pushViewController:selectMemberVC animated:YES];
}

#pragma mark - ChatDetailActionViewDelegate
/**
 *  群组黑名单
 */
- (void)chatDetailActionViewDidSelctGroupBlackList
{
    GruopBlackListViewController *blackVC = [[GruopBlackListViewController alloc] init];
    blackVC.groupId                       = self.emgroup.groupId;
    blackVC.members                       = self.emgroup.members;
    [self.navigationController pushViewController:blackVC animated:YES];
}
/**
 *  解散群组
 */
- (void)chatDetailActionViewDidSelctCloseChatGourp
{
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要解散当前的群组吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag         = 1;
    [alert show];
}
/**
 *  清除聊天记录
 */
- (void)chatDetailActionViewDidSelctCleanAllChatRecord
{
    UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要清除所有的群组聊天记录" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag           = 2;
    [alertView show];

}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        switch (alertView.tag) {
            case 1:
                [self dissmissGroup]; // 解散群组
                break;
            case 2:
                [self cleanAllMessages]; // 清除所有聊天记录
                break;
            case 3:
                [self quitGroupAlert]; // 退出群组
                break;
        }
    }
}
#pragma mark - 解散群组
- (void)dissmissGroup
{
    TYPEWEAKSELF
    [MBProgressHUD showHUD];
    [[EaseMob sharedInstance].chatManager asyncDestroyGroup:self.emgroup.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error)
     {
         [MBProgressHUD dissmiss];
         if (!error) {
             [MBProgressHUD showSuccess:@"解散群组成功" toView:weakSelf.view];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                            {
                                [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1] animated:YES];
                            });
         }
         
     } onQueue:nil];

}

#pragma mark - 清除所有的聊天记录

- (void)cleanAllMessages{
    
    EMConversation  *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.emgroup.groupId
                                                                                conversationType:eConversationTypeGroupChat];
    [conversation removeAllMessages];
    // 发通知清除消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllMessages" object:nil];
}
@end
