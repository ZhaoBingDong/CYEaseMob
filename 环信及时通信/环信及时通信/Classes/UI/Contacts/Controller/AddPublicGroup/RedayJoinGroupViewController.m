//
//  RedayJoinGroupViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/8.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "RedayJoinGroupViewController.h"

@interface RedayJoinGroupViewController ()
<UIAlertViewDelegate>
{
    NSString *_ower; // 群主
}
@end

@implementation RedayJoinGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.title;
}

/**
 *  视图将要出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUD];
    typeof(self)weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:self.groupID completion:^(EMGroup *group, EMError *error) {
        [MBProgressHUD dissmiss];
        if (!error) {
            weakSelf.groupOwer.text = group.owner;
            weakSelf.textLabel.text = group.groupDescription;
            _ower                   = group.owner;
        }
    } onQueue:nil];
    
}
/**
 *  点击了加群的按钮
 */
- (IBAction)button:(UIButton *)sender {
    // 反正添加了自己建的群
    if ([_ower isEqualToString:[CMManager sharedCMManager].userInfo.username]) {
        [MBProgressHUD showError:@"你不能加入自己建的群组" toView: self.view];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"说点啥子嗯" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSString *text = [alertView textFieldAtIndex:0].text;
        [MBProgressHUD showHUD];
        TYPEWEAKSELF
        [[EaseMob sharedInstance].chatManager asyncApplyJoinPublicGroup:weakSelf.groupID withGroupname:weakSelf.title message:text completion:^(EMGroup *group, EMError *error)
        {
            [MBProgressHUD dissmiss];
            if (!error) {
                [MBProgressHUD showSuccess:@"加群申请成功" toView:weakSelf.view];
                NSLog(@"申请成功");
            }else
            {
                [MBProgressHUD showError:error.description toView:weakSelf.view];
            }
            [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[1] animated:YES];
        } onQueue:nil];
    }
}
@end
