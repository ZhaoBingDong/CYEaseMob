//
//  CreatChatGroupViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/8.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//



#import "CreatChatGroupViewController.h"
#import "SelectMemberViewController.h"
@interface CreatChatGroupViewController ()
<UITextFieldDelegate,UITextViewDelegate>
/**
 *  群组的类型
 */
@property(nonatomic,assign)EMGroupStyle style;

@end

@implementation CreatChatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建群组";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.nameTF.placeholder = @"请输入群组名称";
    
    self.placeHoderLabel.text = @"请输入群组简介";
    [self.placeHoderLabel sizeToFit];
    // 导航右侧的 item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加成员" style:UIBarButtonItemStylePlain target:self action:@selector(addItem)];
    self.style = eGroupStyle_Default;
}
/**
 *  添加成员
 */
- (void)addItem
{
//    if ([self.textView.text isEqualToString:@""]||[self.nameTF.text isEqualToString:@""]) {
//        SHOW_ALERT(@"群组名称或者群组简介为空!");
//        return;
//    }
    SelectMemberViewController *memberVC = [[SelectMemberViewController alloc] init];
    memberVC.groupName      = self.nameTF.text;
    memberVC.groupIntroduce = self.textView.text;
    memberVC.style          = self.style;
    [self.navigationController pushViewController:memberVC animated:YES];
}

- (UILabel *)placeHoderLabel
{
    if (!_placeHoderLabel) {
        _placeHoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 5, DEF_SCREEN_WIDTH-52, 110)];
        _placeHoderLabel.font = [UIFont systemFontOfSize:15];
        _placeHoderLabel.textColor = [UIColor lightGrayColor];
        [self.textView addSubview:_placeHoderLabel];
    }
    return _placeHoderLabel;
}

- (IBAction)ValueChange:(UISwitch *)sender {
    BOOL isOpen = sender.isOn;
    if (isOpen)
    {
        if (self.switch2.on==YES) {
            [self.switch2 setOn:NO animated:YES];
        }
        [self.label1 setText:@"共有群"];
        [self.label2 setText:@"加入群组需要管理员同意"];
        self.style = eGroupStyle_PublicJoinNeedApproval;
    }else
    {
        [self.label1 setText:@"私有群"];
        self.style = eGroupStyle_PrivateOnlyOwnerInvite;
        [self.label2 setText:@"不允许群成员邀请其他人"];
    }
}

- (IBAction)valueChange2:(UISwitch *)sender {
    BOOL isOpen = sender.isOn;
    NSString *text = nil;
    if (isOpen)
    {
        if (self.switch1.on==NO) {
            text = @"允许群成员邀请其他人";
            self.style = eGroupStyle_PrivateMemberCanInvite;
        }else{
            text = @"随便加入";
            self.style = eGroupStyle_Default;
        }
    }else
    {
        if (self.switch1.on==NO) {
            self.style = eGroupStyle_PrivateOnlyOwnerInvite;
            text = @"不允许群成员邀请其他人";
        }else{
            self.style = eGroupStyle_PublicOpenJoin;
            text = @"加入群组需要管理员同意";
        }
    }
    [self.label2 setText:text];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegte
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.placeHoderLabel setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length==0) {
        [self.placeHoderLabel setHidden:NO];
    }
}

@end
