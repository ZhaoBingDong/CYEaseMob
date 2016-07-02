//
//  SelectMemberViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/8.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "SelectMemberViewController.h"
#import "SelectMember.h"
@interface SelectMemberViewController ()
<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SelectMemberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择群成员";
    [self.view addSubview:self.tableView];
    // 添加footView
    [self addFootView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}
/**
 *  添加底部的视图
 */
- (void)addFootView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DEF_SCREEN_HEIGHT-50, DEF_SCREEN_WIDTH, 50)];
    self.bottomView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.bottomView];
    // 确定的按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setFrame:CGRectMake(DEF_SCREEN_WIDTH-60-20, 7.5, 60, 35)];
    sureBtn.backgroundColor = DEF_TABBAR_COLOR;
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:sureBtn];
}
/**
 *  视图将要出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取所有的群成员
    [self getAllMembers];
}
/**
 *  获取所有的群成员
 */
- (void)getAllMembers
{
    typeof(self)weakSelf = self;
    // 当获取到联系人后就需要从内存中读取联系人列表
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (EMBuddy *buddy in buddyList) {
        SelectMember *model = [SelectMember new];
        model.title         = buddy.username;
        model.icon          = @"chatListCellHead";
        model.select        = NO;
        [tempArr addObject:model];
    }
    weakSelf.dataArr = tempArr;
    [weakSelf.tableView reloadData];
}
/**
 *  数据源数组
 */
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell.contentView removeAllSubviews];
    SelectMember *model = [self.dataArr objectAtIndex:indexPath.row];
    // 选择框
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 60, 44)];
    
    [button setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [cell.contentView addSubview:button];
    button.selected = model.select;
    // 头像
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake([button right], 7, 30, 30)];
    [iconView setImage:[UIImage imageNamed:model.icon]];
    [cell.contentView addSubview:iconView];
    // 昵称
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([iconView right]+20, 0, 150, 44)];
    [label setText:model.title];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    [cell.contentView addSubview:label];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SelectMember *member = self.dataArr[indexPath.row];
    // 如果 members 不存在表示新建群组选择联系人
    if (!self.members) {
        member.select =!member.select;
        [self.tableView reloadData];
    }else
    {
        // 如果联系人不在你建的群组中 就可以添加他到群组中,已经存在群组中不让重新添加
        BOOL result = [self hasMemberInGroup:member.title];
        if (!result) {
            member.select =!member.select;
            [self.tableView reloadData];
        }else
        {
            [MBProgressHUD showError:@"该联系人已在当前群组中" toView:self.view];
        }
    }
}
/**
 *  选择了确定的按钮
 */
- (void)sureBtnClick:(UIButton *)sender {
    [self creatGroup];
}
/**
 *  仅仅只是创建群组
 */
- (void)creatGroup
{
    NSArray *array =[self appendContact];
    // groupId存在表示进入该控制器是为了给已有的群添加联系人
    if (self.groupId)
    {
        if ([array count] == 0) {
            [MBProgressHUD showError:@"请选择要添加的联系人" toView:self.view];
        }else{
            [self addContactToGroup:array];
        }
        return;
    }
    [MBProgressHUD showHUD];
    // 新建的群选择联系人的界面 如果没有选择联系人将建立一个只有群主一个人的群组
    EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
    groupStyleSetting.groupMaxUsersCount = 500; // 创建500人的群，如果不设置，默认是200人。
    groupStyleSetting.groupStyle = eGroupStyle_PublicOpenJoin; // 创建不同类型的群组，这里需要才传入不同的类型
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:self.groupName
                                                          description:self.groupIntroduce
                                                             invitees:array
                                                initialWelcomeMessage:@"邀请您加入群组"
                                                         styleSetting:groupStyleSetting
                                                           completion:^(EMGroup *group, EMError *error)
     {
         [MBProgressHUD dissmiss];
         if(!error)
         {
             [MBProgressHUD showSuccess:@"创建群组成功" toView:self.view];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 UIViewController *viewController = self.navigationController.viewControllers[1];
                 [self.navigationController popToViewController:viewController animated:YES];
             });
         }
     } onQueue:nil];
}
/**
 *  是否选择了联系人
 */
- (BOOL)selectContact
{
    BOOL flag = NO;
    for (SelectMember *member in self.dataArr) {
        if (member.select==YES) {
            flag = YES;
        }
    }
    return flag;
}
/**
 *  拼接联系人的数组
 */
- (NSArray*)appendContact
{
    // 没有选择联系人返回个空数组
    if ([self selectContact]==NO) {
        return @[];
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (SelectMember *member in self.dataArr) {
        if (member.select==YES) {
            [tempArr addObject:member.title];
        }
    }
    return tempArr;
}
/**
 *  将联系人添加到已有的群组中
 *
 *  @param members 成员
 */
- (void)addContactToGroup:(NSArray*)members
{
    [MBProgressHUD showHUD];
    [[EaseMob sharedInstance].chatManager asyncAddOccupants: members toGroup:self.groupId welcomeMessage:@"欢迎你加群"  completion:^(NSArray *occupants, EMGroup *group, NSString *welcomeMessage, EMError *error) {
        if (!error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD dissmiss];
                [self.navigationController popViewControllerAnimated:YES];
            });
            NSLog(@"创建成功 -- %@",group);
        }
    } onQueue:nil];
}
/**
 *  判断选择的成员在不在已有的群组中,如果已经存在咋不添加该联系人
 *
 *  @param member 选择的联系人
 *
 *  @return 返回 rslut
 */
- (BOOL)hasMemberInGroup:(NSString*)member
{
    BOOL flag = NO;
    for (NSString *name in self.members) {
        if ([member isEqualToString:name]) {
            flag = YES;
            break;
        }
    }
    return  flag;
}
@end
