//
//  AddFriendViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/7.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *_textField; // 输入框
}
@property(nonatomic,strong)NSArray *array; // 数据源数组

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    // 添加头部视图
    [self addHeaderView];
    // 右侧的搜索 item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(searchBtn)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];

    self.tableView.tableFooterView = [[UIView alloc] init];
}
/**
 *  添加头部视图
 */
- (void)addHeaderView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 40)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    // textField
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, DEF_SCREEN_WIDTH-40, 30)];
    textField.placeholder  = @"请输入你要添加的好友";
    textField.borderStyle  = UITextBorderStyleRoundedRect;
    textField.delegate     = self;
    [bgView addSubview:textField];
    _textField             = textField;
    self.tableView.tableHeaderView = bgView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell.contentView removeAllSubviews];
    AddFriendModel *model = [self.array objectAtIndex:indexPath.row];
    // 图片
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7, 30, 30)];
    [iconView setImage:[UIImage imageNamed:@"chatListCellHead"]];
    [cell.contentView addSubview:iconView];
    // 文字
    UILabel *titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake([iconView right]+15, 0, 200, 44)];
    titleLabel.text      = model.name;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font      = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:titleLabel];
    // 添加到按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:DEF_TABBAR_COLOR];
    [addBtn setFrame:CGRectMake(DEF_SCREEN_WIDTH-70, 7, 50, 30)];
    [cell.contentView addSubview:addBtn];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"说点啥子吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

#pragma mark - UITextFieldDelegate  

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (text.length>0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }else{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    return YES;
}

/**
 *  搜索的按钮被点击了
 */
- (void)searchBtn
{
    [_textField resignFirstResponder];
    
    if ([_textField.text isEqualToString:[CMManager sharedCMManager].userInfo.username]) {
        SHOW_ALERT(@"你不能添加自己为好友!");
        return;
    }
    AddFriendModel *model = [[AddFriendModel alloc] init];
    model.name            = _textField.text;
    self.array            = @[model];
    [self.tableView reloadData];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (buttonIndex==1)
    {
        if ([textField.text length]==0) return;
        EMError *error = nil;
        UserInfo *userInfo = [CMManager currentUser];
        NSString *message = [NSString stringWithFormat:@"%@：%@", userInfo.username, textField.text];
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:_textField.text message:message error:&error];
        if (isSuccess && !error)
        {
            NSLog(@"添加成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}

@end

@implementation AddFriendModel


@end
