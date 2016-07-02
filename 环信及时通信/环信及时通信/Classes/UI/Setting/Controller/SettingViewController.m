//
//  SettingViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/6.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingItem.h"
#import "SetupPushNoticeViewController.h"
#import "AppDelegate.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  数据源数组
 */
@property(nonatomic,strong)NSArray *dataArr;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加设置的 items
    [self loadDatas];
    // 添加 footView
    [self addFootView];
}
/**
 *  添加设置 items
 */
- (void)loadDatas
{
    // 自动登录
    SettingItem *autoLogin           = [SettingItem new];
    autoLogin.title                  = @"自动登录";
    autoLogin.switchOperation        = ^(BOOL isOpen){
        // 设置是否自动登录
        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:isOpen];
        BOOL autoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
        NSLog(@"--%@",autoLogin==YES?@"自动登录":@"不是自动登录");
    };
    autoLogin.isOpen                 = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    autoLogin.type                   = AccessViewTypeSwitch;
    // 推送消息设置
    SettingItem *noticeSetup         = [SettingItem new];
    noticeSetup.title                = @"推送消息设置";
    noticeSetup.showVC               = [SetupPushNoticeViewController class];
    noticeSetup.type                 = AccessViewTypeArrow;
    // 黑名单
    SettingItem *blackList           = [SettingItem new];
    blackList.title                  = @"黑名单";
    blackList.type                   = AccessViewTypeArrow;
    // 诊断
    SettingItem *diacrisis           = [SettingItem new];
    diacrisis.title                  = @"诊断";
    diacrisis.type                   = AccessViewTypeArrow;
    // 使用 IP
    SettingItem *useIP               = [SettingItem new];
    useIP.title                      = @"使用IP";
    useIP.isOpen                     = NO;
    useIP.switchOperation            = ^(BOOL isOpen){
        NSLog(@"--%@",isOpen==YES?@"开启":@"关闭");
    };
    useIP.type                       = AccessViewTypeSwitch;
    // 退出时删除会话
    SettingItem *exitGroup           = [SettingItem new];
    exitGroup.title                  = @"退群时删除会话";
    exitGroup.isOpen                 = NO;
    exitGroup.switchOperation            = ^(BOOL isOpen){
        NSLog(@"--%@",isOpen==YES?@"开启":@"关闭");
    };
    exitGroup.type                   = AccessViewTypeSwitch;
    // ios离线时推送昵称
    SettingItem *unOnlineShowName    = [SettingItem new];
    unOnlineShowName.title           = @"iOS 离线推送昵称";
    unOnlineShowName.isOpen          = NO;
    unOnlineShowName.type            = AccessViewTypeArrow;
    // 显示视频通话信息
    SettingItem *showFaceToFaceTalk  = [SettingItem new];
    showFaceToFaceTalk.title         = @"显示视频通过信息";
    showFaceToFaceTalk.isOpen        = NO;
    showFaceToFaceTalk.switchOperation            = ^(BOOL isOpen){
        NSLog(@"--%@",isOpen==YES?@"开启":@"关闭");
    };
    showFaceToFaceTalk.type          = AccessViewTypeSwitch;
    // 个人信息
    SettingItem *prefileInfo         = [SettingItem new];
    prefileInfo.title                = @"个人信息";
    prefileInfo.type                 = AccessViewTypeArrow;

    self.dataArr = @[autoLogin,noticeSetup,blackList,diacrisis,useIP,exitGroup,unOnlineShowName,showFaceToFaceTalk,prefileInfo];
    [self.tableView reloadData];
}
/**
 *  添加表的尾部视图
 */
- (void)addFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,60)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, DEF_SCREEN_WIDTH-20, 40)];
    button.backgroundColor = [UIColor redColor];
    NSString *username = [CMManager sharedCMManager].userInfo.username;
    [button setTitle:[NSString stringWithFormat:@"退出登录: %@",username] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:button];
    [button addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footView;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    // 设置的模型
    SettingItem *item = self.dataArr[indexPath.row];
    cell.textLabel.text = item.title;
    switch (item.type)
    {
        case AccessViewTypeArrow: // 跳转箭头
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case AccessViewTypeSwitch: // 开关
        {
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
            switchView.tag       = indexPath.row;
            [switchView setOn:item.isOpen animated:YES];
            [switchView addTarget:self action:@selector(turnOn:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SettingItem *item = [self.dataArr objectAtIndex:indexPath.row];
    // 有跳转的控制器就跳转到相应的控制器
    if (item.type == AccessViewTypeArrow) {
        if (item.showVC) {
            UIViewController *showVC = [[item.showVC alloc] init];
            [self.navigationController pushViewController:showVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}
#pragma mark - 开关的点击事件

- (void)turnOn:(UISwitch*)switchView
{
    // 如果 itemOperation 存在 就把按钮的开关状态传给它
    SettingItem *item = self.dataArr[switchView.tag];
    if (!item.switchOperation) return;
    item.switchOperation(switchView.on);
}

- (void)loginOut:(UIButton*)btn
{
    [MBProgressHUD showHUD];
    __block  EMError *error = nil;
    // 开启异步线程将这个同步任务放到异步线程中 这样主线程的 UI 不会被影响到
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSDictionary *info = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:&error];
        if (!error && info)
        {
            [HMFileManager removeUserDataForkey:DEF_PASSWORD];
        }
    }];
    // 异步线程结束后刷新主线程 UI
    [operation setCompletionBlock:^{
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [MBProgressHUD dissmiss];
            [AppDelegate didLoginOut];
        }];
    }];
    // 把任务放到队列中执行
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}
- (void)dealloc
{
    NSLog(@"-------");
}
@end
