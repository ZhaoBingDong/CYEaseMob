//
//  UpadataGroupTitleViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "UpadataGroupTitleViewController.h"
#import "GroupDetailController.h"
#import "ChatGroupRoomViewController.h"
@interface UpadataGroupTitleViewController ()
<EMChatManagerDelegate>
@end

@implementation UpadataGroupTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改群昵称";
    // 右侧的保存按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction:)];
    [self.textField setPlaceholder:@"请输入群组名称"];
    if (self.nickname&&[self.nickname length]>0) {
        [self.textField setText:self.nickname];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)saveAction:(UIBarButtonItem*)barItem
{
    [MBProgressHUD showHUD];
    TYPEWEAKSELF
    // 修改群名称
    [[EaseMob sharedInstance].chatManager asyncChangeGroupSubject:self.textField.text forGroup:self.groupId completion:^(EMGroup *group, EMError *error) {
        [MBProgressHUD dissmiss];
        if (!error) {
            NSString *nickname = weakSelf.textField.text;
            // 获取导航控制器的子控制器个数和所有子控制器
            NSArray *childViewControllers = weakSelf.navigationController.viewControllers;
            NSInteger childViewControllerCount = weakSelf.navigationController.childViewControllers.count;
            // 群组详情的控制器
            GroupDetailController *detailVC = childViewControllers[childViewControllerCount-2];
            // 群组房间的控制器
            ChatGroupRoomViewController *roomVC = childViewControllers[childViewControllerCount-2];
            roomVC.title                        = nickname;
            detailVC.title                      = nickname;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } onQueue:nil];
}

@end
