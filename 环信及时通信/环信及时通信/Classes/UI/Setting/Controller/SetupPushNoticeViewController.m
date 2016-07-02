//
//  SetupPushNoticeViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/6.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "SetupPushNoticeViewController.h"

@interface SetupPushNoticeViewController ()
/**
 *  数组
 */
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation SetupPushNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息推送设置";
}
/**
 *  懒加载数组
 */
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray arrayWithObjects:@"声音提醒",@"震动提醒" ,nil];
    }
    return _dataArray;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text     = [self.dataArray objectAtIndex:indexPath.row];
    UISwitch *swithcView    = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    NSInteger isOpen             = [[HMFileManager readUserDataForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] integerValue];
    if (isOpen == 0) {
        [swithcView setOn:NO];
    }else{
        [swithcView setOn:YES];
    }
    swithcView.tag          = indexPath.row;
    [swithcView addTarget:self action:@selector(turn:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView      = swithcView;
    
    return cell;
}

- (void)turn:(UISwitch*)stch
{
    if (stch.tag == 0) {
        [[SoundManager sharedSoundManager] setCanPlaySound:stch.on];
    }
    if (stch.on == YES) {
        [HMFileManager saveUserData:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)stch.tag]];
    }else{
        [HMFileManager saveUserData:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)stch.tag]];
    }
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
