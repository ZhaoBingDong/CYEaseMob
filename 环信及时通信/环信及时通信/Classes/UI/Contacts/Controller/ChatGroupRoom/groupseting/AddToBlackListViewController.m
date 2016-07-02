//
//  AddToBlackListViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "AddToBlackListViewController.h"
#import "SelectMember.h"
@interface AddToBlackListViewController ()

@end

@implementation AddToBlackListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title  = @"添加黑名单";
}
/**
 *  视图将要出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    // 获取群成员列表
    [self getAllMembers];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SelectMember *member = self.dataArr[indexPath.row];
    if (member.isInBlackList) {
        [MBProgressHUD showError:@"该联系人已经在黑名单中" toView:self.view];return;
    }
    // 如果 members 不存在表示新建群组选择联系人
    member.select =!member.select;
    [self.tableView reloadData];
}
/**
 *  获取群成员列表
 */
- (void)getAllMembers
{
    [MBProgressHUD showHUD];
    for (NSString *str in self.members)
    {
        SelectMember *model = [SelectMember new];
        model.title         = str;
        model.icon          = @"chatListCellHead";
        model.select        = NO;
        // 判断是否在黑名单中 这个方法不需要了
//        model.isInBlackList   = [self memberHasInBliacklist:str];
        if (![model.title isEqualToString:[CMManager sharedCMManager].userInfo.username]) {
            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
    }
    [MBProgressHUD dissmiss];
}

/**
 *  确定的按钮
 */
- (void)sureBtnClick:(UIButton *)sender
{
    TYPEWEAKSELF
    NSArray *array =[self appendContact];
    [MBProgressHUD showHUD];
    [[EaseMob sharedInstance].chatManager asyncBlockOccupants:array fromGroup:self.groupId completion:^(EMGroup *group, EMError *error) {
        [MBProgressHUD dissmiss];
        if (!error) {
            [MBProgressHUD showSuccess:@"加入黑名单成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } onQueue:nil];
}
///**
// *  成员已经在黑名单中了
// *
// *  @param member 成员
// */
//- (BOOL)memberHasInBliacklist:(NSString*)member
//{
//    BOOL flag = NO;
//    for (NSString *name in self.blackList) {
//        if ([member isEqualToString:name]) {
//            flag = YES;
//            break;
//        }
//    }
//    return flag;
//}

@end
