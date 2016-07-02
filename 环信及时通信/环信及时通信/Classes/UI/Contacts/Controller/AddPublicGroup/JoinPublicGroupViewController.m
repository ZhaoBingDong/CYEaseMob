//
//  JoinPublicGroupViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/8.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "JoinPublicGroupViewController.h"
#import "ChatGroupModel.h"
#import "RedayJoinGroupViewController.h"
@interface JoinPublicGroupViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
/**
 *  数据源数组
 */
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation JoinPublicGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"共有群组";
    // 添加刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(headRefresh)];
    self.tableView.tableFooterView = [UIView new];
}

/**
 *  视图将要出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 请求公共群组的数据
    [self getAllPublicGroups];
    
}
/**
 *  获取共有群组
 */
- (void)getAllPublicGroups
{
    __weak JoinPublicGroupViewController *weakSelf = self;
    [MBProgressHUD showHUD];
    [[EaseMob sharedInstance].chatManager asyncFetchAllPublicGroupsWithCompletion:^(NSArray *groups, EMError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [MBProgressHUD dissmiss];
        if (!error)
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (EMGroup *group in groups)
            {
                ChatGroupModel *creatGroup = [[ChatGroupModel alloc] init];
                creatGroup.title           = group.groupSubject;
                creatGroup.icon            = @"groupPrivateHeader";
                creatGroup.groupId         = group.groupId;
                // 过滤掉自己建的群或者加过的群
                BOOL flag                  = [self hasMemberOwer:group];
                if (!flag) {
                    [tempArray addObject:creatGroup];
                }
            }
            weakSelf.dataArray = tempArray;
            [weakSelf.tableView reloadData];
        }
    } onQueue:nil];
}
/**
 *  判断我参与和我建的群是否跟公开群中的任意一个相同,既不再获取我已经有的群
 */
- (BOOL)hasMemberOwer:(EMGroup*)members
{
    BOOL flag = NO;
    NSArray *groupList = [[EaseMob sharedInstance].chatManager groupList];
    for (EMGroup *group in groupList) {
        if ([group.groupId isEqualToString:members.groupId]) {
            flag = YES;
        }
    }
    return flag;
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
    ChatGroupModel *group                = self.dataArray[indexPath.row];
    RedayJoinGroupViewController *joinVC = [[RedayJoinGroupViewController alloc] init];
    joinVC.title                         = group.title;
    joinVC.groupID                       = group.groupId;
    [self.navigationController pushViewController:joinVC animated:YES];
}

#pragma mark - 下拉刷新

- (void)headRefresh
{
    [self getAllPublicGroups];
}
@end
