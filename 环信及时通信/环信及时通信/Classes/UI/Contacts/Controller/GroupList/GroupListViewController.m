//
//  GroupListViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/7.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "GroupListViewController.h"
#import "ChatGroupModel.h"
#import "CreatChatGroupViewController.h"
#import "EMGroup.h"
#import "JoinPublicGroupViewController.h"
#import "ChatGroupRoomViewController.h"
@interface GroupListViewController ()
<UITableViewDataSource,UITableViewDelegate,EMChatManagerGroupDelegate,EMChatManagerDelegate>
@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组";
    // 添加数据源
    [self loadDatas];
    // 设置 footView
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}
/**
 *  添加数据源
 */
- (void)loadDatas
{
    // 建群组
    ChatGroupModel *creatGroup = [[ChatGroupModel alloc] init];
    creatGroup.title           = @"新建群组";
    creatGroup.showClass       = [CreatChatGroupViewController class];
    creatGroup.icon            = @"group_creategroup";
    // 加入一个群组
    ChatGroupModel *joinGroup  = [[ChatGroupModel alloc] init];
    joinGroup.title            = @"添加公开群";
    joinGroup.icon             = @"group_joinpublicgroup";
    joinGroup.showClass        = [JoinPublicGroupViewController class];
    [self.dataArr addObject:@[creatGroup,joinGroup]];
    [self.tableView reloadData];
}
/**
 *  视图将要出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**
     *  获取群组的信息
     */
    [self getGroups];
}
/**
 *  获取我的群组信息
 */
- (void)getGroups
{
    [MBProgressHUD showHUD];
    typeof(self)weakSelf = self;
    // 请求已有的群组
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        [MBProgressHUD dissmiss];
        if (!error) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (EMGroup *group in groups)
            {
                ChatGroupModel *creatGroup = [[ChatGroupModel alloc] init];
                creatGroup.title           = group.groupSubject;
                creatGroup.icon            = @"groupPrivateHeader";
                creatGroup.groupId         = group.groupId;
                creatGroup.emGruop         = group;
                [tempArray addObject:creatGroup];
            }
            if (weakSelf.dataArr.count>1) {
                [weakSelf.dataArr removeLastObject];
            }
            [weakSelf.dataArr addObject:tempArray];
            [weakSelf.tableView reloadData];
        }
    } onQueue:nil];
}



/**
 *  懒加载数据源数组
 */
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArr objectAtIndex:section] count];
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
    NSArray *array = [self.dataArr objectAtIndex:indexPath.section];
    ChatGroupModel *group = [array objectAtIndex:indexPath.row];
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
    
    ChatGroupModel *group = [[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (group.showClass) // 去加群或者添加公共群的控制器
    {
        UIViewController *vc =[[group.showClass alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section ==1) // 去群聊天的控制器
    {
        ChatGroupRoomViewController *roomVC = [[ChatGroupRoomViewController alloc] init];
        roomVC.title                        = group.title;
        roomVC.groupID                      = group.groupId;
        [self.navigationController pushViewController:roomVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.0000000f;
    }
    return 20;
}

/**
 *  加群成功后的回调方法
 *
 *  @param group 加群了
 *  @param error 错误
 */
- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId groupname:(NSString *)groupname error:(EMError *)error
{
    [[SoundManager sharedSoundManager]musicPlayByName:@"system.caf"];
    [MBProgressHUD showSuccess:@"群主同意加群成功" toView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getGroups];
    });
}


@end
