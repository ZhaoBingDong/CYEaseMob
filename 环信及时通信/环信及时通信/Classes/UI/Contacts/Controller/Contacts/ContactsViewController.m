//
//  ContactsViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/6.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ContactsViewController.h"
#import "AddFriendViewController.h"
#import "ChatListTableViewCell.h"
#import "ContactModel.h"
#import "NotifyViewController.h"
#import "GroupListViewController.h"
@interface ContactsViewController ()
<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataArr; // 数据源 dataArray
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend:)];
    self.tableView.tableFooterView = [UIView new];
    // 加载数据
    [self loadDatas];
}
/**
 *  loadDatas
 */
- (void)loadDatas
{
    //  申请与通知
    ContactModel *notice   = [ContactModel new];
    notice.username        = @"申请与通知";
    notice.icon            = @"newFriends";
    // 群组
    ContactModel *groups   = [ContactModel new];
    groups.username        = @"群组";
    groups.icon            = @"groupPrivateHeader";
    // 聊天室列表
    ContactModel *chatRoom = [ContactModel new];
    chatRoom.username      = @"聊天室列表";
    chatRoom.icon          = @"groupPrivateHeader";
    // 环信助手
    ContactModel *helper   = [ContactModel new];
    helper.username        = @"环信助手";
    helper.icon            = @"groupPrivateHeader";
    self.dataArr           = [NSMutableArray array];
    [self.dataArr addObject:@[notice,groups,chatRoom,helper]];
    [self.tableView reloadData];
}
/**
 *  视图将要出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    typeof(self)weakSelf = self;
    
    // 获取好友的列表的接口
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error)
        {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (EMBuddy *buddy in buddyList) {
                ContactModel *model = [ContactModel new];
                model.username      = buddy.username;
                model.icon          = @"chatListCellHead";
                [tempArr addObject:model];
            }
            ContactModel *myModel = [ContactModel new];
            myModel.username      = [CMManager sharedCMManager].userInfo.username;
            myModel.icon          = @"chatListCellHead";
            [tempArr insertObject:myModel atIndex:0];
            if (self.dataArr.count>1) {
                [weakSelf.dataArr removeLastObject];
            }
            [weakSelf.dataArr addObject:tempArr];
            [weakSelf.tableView reloadData];
        }
    } onQueue:nil];
}
/**
 *  添加好友
 */
- (void)addFriend:(UIBarButtonItem*)item
{
    AddFriendViewController *addVC = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.dataArr objectAtIndex:section];
    return [array count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ChatListTableViewCell";
    ChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        NSObject *objcet = [[[NSBundle mainBundle] loadNibNamed:@"ChatListTableViewCell" owner:nil options:nil] lastObject];
        if ([objcet isKindOfClass:[ChatListTableViewCell class]]) {
            cell = (ChatListTableViewCell*)objcet;
        }
    }
    NSArray *array  = self.dataArr[indexPath.section];
    ContactModel *model = [array objectAtIndex:indexPath.row];
    cell.label.text     = model.username;
    [cell.iconView setImage:[UIImage imageNamed:model.icon]];
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return @"联系人";
    }
    return @"分类";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==1) return;
    if (indexPath.row==0) {
        NotifyViewController *notifyVC = [[NotifyViewController alloc] init];
        [self.navigationController pushViewController:notifyVC animated:YES];
    }else if (indexPath.row==1){
        GroupListViewController *groupVC = [[GroupListViewController alloc] init];
        [self.navigationController pushViewController:groupVC animated:YES];
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *mutableArr = self.dataArr[indexPath.section];
    ContactModel *model = mutableArr[indexPath.row];
    EMError *error = nil;
    // 删除好友
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:model.username removeFromRemote:YES error:&error];
    if (isSuccess && !error)
    {
        NSLog(@"删除成功");
        [mutableArr removeObject:model];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row==0)
    {
       return NO;
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
@end
