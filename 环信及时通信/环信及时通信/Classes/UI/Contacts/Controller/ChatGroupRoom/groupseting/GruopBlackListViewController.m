//
//  GruopBlackListViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "GruopBlackListViewController.h"
#import "ChatGroupModel.h"
#import "AddToBlackListViewController.h"

@interface GruopBlackListViewController ()

@end

@implementation GruopBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组黑名单";
    // 右侧的保存按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"加入黑名单" style:UIBarButtonItemStyleDone target:self action:@selector( addBlackList:)];
    self.tableVeiw.tableFooterView = [UIView new];
}
/**
 *  视图将要出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 请求黑名单的接口
    [self requestGroupBans];
}
/**
 *  请求黑名单的接口
 */
- (void)requestGroupBans
{
    TYPEWEAKSELF
    [MBProgressHUD showHUD];
    [[EaseMob sharedInstance].chatManager asyncFetchGroupBansList:self.groupId completion:^(NSArray *groupBans, EMError *error) {
        [MBProgressHUD dissmiss];
        if (!error) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSString *name in groupBans)
            {
                ChatGroupModel *creatGroup = [[ChatGroupModel alloc] init];
                creatGroup.title           = name;
                creatGroup.icon            = @"groupPrivateHeader";
                [tempArr addObject:creatGroup];
            }
            weakSelf.dataArray = tempArr;
        }
        [weakSelf.tableVeiw reloadData];
    } onQueue:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell.contentView removeAllSubviews];
    // 取出模型
    ChatGroupModel *group = [self.dataArray objectAtIndex:indexPath.row];
    // 图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 30, 30)];
    [imageView setImage:[UIImage imageNamed:group.icon]];
    [cell.contentView addSubview:imageView];
    // label
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake([imageView right]+15, 0, 200, 44)];
    label.text      = group.title;
    label.font      = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    [cell.contentView addSubview:label];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count==0) return;
    [MBProgressHUD showHUD];
    TYPEWEAKSELF
    ChatGroupModel *group = [self.dataArray objectAtIndex:indexPath.row];
    [[EaseMob sharedInstance].chatManager asyncUnblockOccupants:@[group.title] forGroup:self.groupId completion:^(EMGroup *group, EMError *error) {
        [MBProgressHUD dissmiss];
        if (!error) {
            [weakSelf requestGroupBans];
        }
    } onQueue:nil];

}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"解除黑名单";
}

#pragma mark - 添加到黑名单

- (void)addBlackList:(UIBarButtonItem*)item
{
    if (self.members.count==0) {
        [MBProgressHUD showError:@"没有可以添加到黑名单的成员" toView: self.view];
        return;
    }
    // 获取所有黑名单人的昵称
    NSMutableArray *tempArr = [NSMutableArray array];
    for (ChatGroupModel *group in self.dataArray) {
        NSString *title = group.title;
        [tempArr addObject:title];
    }
    AddToBlackListViewController *addToVC = [[AddToBlackListViewController alloc] init];
    addToVC.groupId                       = self.groupId;
    addToVC.members                       = self.members;
    addToVC.blackList                     = tempArr;
    [self.navigationController pushViewController:addToVC animated:YES];
}


@end
