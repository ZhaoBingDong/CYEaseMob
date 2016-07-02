
//  NotifyViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/7.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "NotifyViewController.h"
#import "NotifyModel.h"
#import "NotifyBubbyViewCell.h"
@interface NotifyViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation NotifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.tableView.tableFooterView = [UIView new];
    TYPEWEAKSELF
    // 监听建群通知
    [[CMManager sharedCMManager]setDidReceiveApplyToJoinGroup:^(NSMutableArray *notices)
    {
        weakSelf.dataArray = notices;
        [weakSelf.tableView reloadData];
    }];
}
/**
 *  视图已经消失
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 加载数据
    [self loadDatas];
}
/**
 *  加载数据
 */
- (void)loadDatas
{
    NSMutableArray *tempArr = [CMManager sharedCMManager].notices;
    if ([tempArr count]==0) {
        tempArr =  [HMFileManager getObjectByFileName:@"notices"];
    }
    self.dataArray          = tempArr;
    [self.tableView reloadData];
}
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
    static NSString *cellID = @"NotifyBubbyViewCell";
    NotifyModel *noti       = self.dataArray[indexPath.row];
    NSString    *icon       = [noti.type isEqualToString:@"1"]?@"groupPrivateHeader.png":@"chatListCellHead.png";
    // 加群的通知
    NotifyBubbyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        NSObject *objcet = [[[NSBundle mainBundle] loadNibNamed:@"NotifyBubbyViewCell" owner:nil options:nil] lastObject];
        if ([objcet isKindOfClass:[NotifyBubbyViewCell class]]) {
            cell = (NotifyBubbyViewCell*)objcet;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.badgeView.layer.cornerRadius = 7.5;
        cell.badgeView.clipsToBounds      = YES;
        cell.sender.tag                   = indexPath.row;
        cell.agree.tag                    = indexPath.row;
        // 拒绝按钮的事件
        [cell.sender addTarget:self action:@selector(notArrowJoin:) forControlEvents:UIControlEventTouchUpInside];
        // 同意的按钮事件
        [cell.agree addTarget:self action:@selector(arrowJoin:) forControlEvents:UIControlEventTouchUpInside];
    }
    // 左边的 icon
    [cell.iconView setImage:[UIImage imageNamed:icon]];
    // 昵称
    [cell.nameLabel setText:noti.username];
    // 详情
    [cell.subTitleLabel setText:[NSString stringWithFormat:@"%@: %@",noti.username,noti.reason]];
    // badgeView是否显示
    cell.badgeView.hidden = noti.isRead;
    if (noti.isRead == YES)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH-100, 0, 100, 70)];
        label.textAlignment   = DEF_TextAlignmentCenter;
        label.textColor       = [UIColor grayColor];
        label.font            = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label];
        if ([noti.isArrow isEqualToString:@"1"])
        {
            label.text = @"已同意";
        }else if([noti.isArrow isEqualToString:@"2"])
        {
            label.text = @"已拒绝";
        }else
        {
            [label removeFromSuperview];
        }
        if ([noti.isArrow isEqualToString:@"0"]==NO) {
            [cell.sender setHidden:YES];
            [cell.agree setHidden:YES];
        }
    }
    return cell;
    
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NotifyModel *notice     = self.dataArray[indexPath.row];
    notice.isRead           = YES;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - notArrowJoinGroup

- (void)notArrowJoin:(UIButton*)notJoin
{
    NotifyModel *notice     = self.dataArray[notJoin.tag];
    NSString    *groupId    = notice.groupId;
    NSString    *groupname  = notice.groupName;
    NSString    *userName   = notice.username;

    [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:groupId groupname:groupname toApplicant:userName reason:@"拒绝加入该群"];
    notice.isRead           = YES;
    notice.isArrow          = @"0";
    [self.dataArray removeObject:notice];
    [CMManager sharedCMManager].notices = self.dataArray;
    NSLog(@"----%@",[CMManager sharedCMManager].notices);
    
    [self.tableView reloadData];
}

- (void)arrowJoin:(UIButton*)notJoin
{

    NotifyModel *notice     = self.dataArray[notJoin.tag];
    NSString    *groupId    = notice.groupId;
    NSString    *groupname  = notice.groupName;
    NSString    *userName   = notice.username;
    TYPEWEAKSELF
    [MBProgressHUD showHUD];
    [[EaseMob sharedInstance].chatManager asyncAcceptApplyJoinGroup:groupId groupname:groupname applicant:userName completion:^(EMError *error)
    {
        [MBProgressHUD dissmiss];
        if (!error) {
            notice.isRead = YES;
            notice.isArrow = @"1";
            [weakSelf.dataArray removeObject:notice];
            [CMManager sharedCMManager].notices = weakSelf.dataArray;
            [weakSelf.tableView reloadData];
        }
    } onQueue:nil];

}
@end
