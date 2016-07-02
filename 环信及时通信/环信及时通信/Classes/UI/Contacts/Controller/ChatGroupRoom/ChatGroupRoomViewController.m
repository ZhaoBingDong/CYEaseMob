//
//  ChatGroupRoomViewController.m
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ChatGroupRoomViewController.h"
#import "GroupDetailController.h"
#import "KeyboardView.h"
#import "EMMessage.h"
#import "ChatMessage.h"
#import "ChatBaseFrame.h"
#import "UserChatTextViewCell.h"
#import "ChatMessageBodies.h"
#import "UserChatBaseViewCell.h"
#import "ChatImageFrame.h"
#import "BMShowUIView.h"
#import "DTShowHudView.h"
#import "BMSendMessageHandle.h"
#import "UserChatImageCell.h"
#import "MJPhoto.h"
#import "MJPhotoView.h"
#import "MJPhotoBrowser.h"
@interface ChatGroupRoomViewController ()
<
    UIAlertViewDelegate,        //alertview 协议
    EMChatManagerDelegate,      // 聊天管理者的协议
    KeyboardViewDelegate,       // 键盘工具条协议
    UITableViewDataSource,      // UITableView数据源
    UITableViewDelegate ,       // UITableView代理
    UserChatCellProtocol   // 点击图片消息的气泡
>
@end

@implementation ChatGroupRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 监听聊天消息
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    //添加键盘
    self.keyboardView = [[KeyboardView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width,40)];
    self.keyboardView.selfSuperView = self.view;
    self.keyboardView.mydelegate = self;
    [self.view addSubview:self.keyboardView];
    //根据接收者的username获取当前会话的管理者
    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.groupID
    conversationType:eConversationTypeGroupChat];
    // 给 tableView 添加点击手势
    [self.view addSubview:self.tableView];
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
    self.needScrollToBottom     = YES;
    _lastMessageId              = @"";
    // 监听清除消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllMessages:) name:@"RemoveAllMessages" object:nil];
    // 右侧导航看群设置的按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"group_detail.png"] style:UIBarButtonItemStyleDone target:self action:@selector(group_detail)];
    // 获取历史记录
    [self getHistoryMessageWithMessageId:nil];
    // 加载活动指示器
    [self.view addSubview:self.activityView];
    self.needRefresh      = YES;
}
/**
 *  懒加载活动指示器
 */
- (UIView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, 20)];
        _activityView.hidden          = YES;
        // 加载活动指示器
        UIActivityIndicatorView *activityIndicatorView      = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH/2 -60, 0, 15, 15)];
        activityIndicatorView.activityIndicatorViewStyle    = UIActivityIndicatorViewStyleGray;
        [_activityView addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
        // label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([activityIndicatorView right]+40, 0, 100, 15)];
        label.text     = @"加载中...";
        label.textColor = [UIColor lightGrayColor];
        label.font     = FOUN_SIZE(12);
        [_activityView addSubview:label];
    }
    return _activityView;
}
/**
 *  懒加载 tableView
 */
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-104) style:UITableViewStylePlain];
        _tableView.delegate     = self;
        _tableView.dataSource   = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
/**
 *  懒加载聊天的大数组
 */
- (NSMutableArray *)chatArray
{
    if (!_chatArray) {
        _chatArray = [NSMutableArray array];
    }
    return _chatArray;
}
/**
 *  历史纪录的数组
 */
- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSMutableArray array];
    }
    return _historyArray;
}
/**
 *  视图将要出现
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
// 获取历史聊天的数据
- (void)getHistoryMessageWithMessageId:(NSString*)messageId
{
    [BMSendMessageHandle getHistroyMessageByMessageId:messageId atViewController:self];
}
/**
 *  视图已经出现
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.needRefresh == NO) return;
    // 获取群组信息
    [self requestGroupInfo];
}
/**
 *  获取群组信息 
 */
- (void)requestGroupInfo
{
    [BMSendMessageHandle requestGroupInfoAtViewController:self];
}
/**
 *  去查看群组详情的控制器
 */
- (void)group_detail
{
    GroupDetailController *detailVC = [[GroupDetailController alloc] init];
    detailVC.emgroup                    = self.emGroup;
    detailVC.title                      = self.emGroup.groupSubject;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - 点击表空白地方退出键盘

- (void)tapClick
{
    [self.keyboardView allSubviewsResignFirstResponder];
}
#pragma mark - KeyboardViewDelegate
/**
 *  点击了发消息的按钮
 *
 *  @param message 消息文本
 */
- (void)keyboardViewDidSendMessage:(NSString *)message
{
    [self sendTextMessage:message];
}
/**
 *  点击了键盘上的发送图片的按钮
 */
- (void)keyboardViewDidSendImageView
{
    TYPEWEAKSELF
    NSArray *images = @[@"chatBar_colorMore_photo",@"chatBar_colorMore_location",@"chatBar_colorMore_camera",@"chatBar_colorMore_audioCall",@"chatBar_colorMore_video"];
    [DTShowHudView showShareViewWithContents:images successBlock:^(NSInteger index)
    {
        switch (index) {
            case 0:
            {
                [weakSelf showImagePickerControllerWithType:ImagePickerViewControllerPhotoLibrary];
            }
             break;
            case 1:
                
                break;
                
            case 2:
                [weakSelf showImagePickerControllerWithType:ImagePickerViewControllerCamera];
                break;
            default:
                break;
        }
        
    } showInView:self.view];
}
/**
 *  打开相册或者相机
 *
 *  @param type 打开的类型
 */
- (void)showImagePickerControllerWithType:(ImagePickerViewControllerSourceType)type
{
    TYPEWEAKSELF
    self.needRefresh   = NO;
    [BMShowUIView showImagePickerViewControllerInViewControler:self sourceType:type completeBlock:^(UIImage *image, id infoDict) {
        weakSelf.needRefresh  = YES;
        [weakSelf sendImageMessage:image];
    }];
}
/**
 *  键盘位置发送了改变
 *
 *  @param topPositon 键盘顶部的位置
 */
- (void)keyboardViewChangePosition:(CGFloat)topPositon
{
    TYPEWEAKSELF
    CGFloat tableViewHeight = topPositon - 64;
   [UIView animateWithDuration:0.27 animations:^{
        [weakSelf.tableView setHeight:tableViewHeight];
        [weakSelf reloadTableView];
   }];
}
#pragma mark - EMChatManagerDelegate
/**
 *  接受在线的消息
 *
 *  @param message 消息
 */
-(void)didReceiveMessage:(EMMessage *)message
{
    [BMSendMessageHandle didReceiveMessage:message atViewController:self];
}
#pragma mark - 发送普通的文本消息
/**
 *  发送文本消息
 *
 *  @param message 消息
 */
- (void)sendTextMessage:(NSString*)message
{
    [BMSendMessageHandle sendTextMessageWithText:message atViewController:self];
}
/**
 *  发送图片
 *
 *  @param image 图片
 */
- (void)sendImageMessage:(UIImage*)image
{
    [BMSendMessageHandle sendImageMessage:image atViewController:self];
}
/**
 *  刷新表视图
 */
- (void)reloadTableView
{
    [self.tableView reloadData];
    if (!self.needScrollToBottom)   return;
    if ([self.chatArray count]>0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.chatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chatArray count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatBaseFrame *frame            = [self.chatArray objectAtIndex:indexPath.row];
    UserChatBaseViewCell *baseCell  = nil;
    // 消息类型
    MessageBodyType  messageType    = frame.chatMessage.messagebodies.messageBodyType;
    switch (messageType) {
        case eMessageBodyType_Text:  // 文本消息用文本消息的 Cell

        {
           baseCell                 = [UserChatTextViewCell registUserChatTextViewCell:tableView];
   
        }
            break;
            
       case eMessageBodyType_Image: // 图片消息用图片消息的Cell
        {
            baseCell                = [UserChatImageCell registUserChatImageMessageViewCell:tableView];
            // 图片所在单元格的索引
            frame.imageIndex        = indexPath.row;
            baseCell.delete         = self;
        }
            break;
        case eMessageBodyType_Voice:// 语音消息用语音消息的Cell 
        {
            
        }
            break;
        default:
            break;
    }
    // frame模型
    baseCell.cellFrame              = frame;
   
    return baseCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatBaseFrame *frame = self.chatArray[indexPath.row];
    return frame.cellHeight;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y==0) {
        if (self.chatArray.count ==0 ) return;
        self.needScrollToBottom     = NO;
        ChatBaseFrame *frame        = self.chatArray[0];
        ChatMessage   *message      = frame.chatMessage;
        NSString      *messageID    = message.messageId;
        // 没有历史消息了 就不用请求接口了 即 messageID == _lastMessage
        if ([messageID isEqualToString:_lastMessageId]) {
            return;
        }
        [self getHistoryMessageWithMessageId:messageID];
    }
}
- (void)dealloc
{
    [self.historyArray removeAllObjects];
    [self.chatArray removeAllObjects];
    self.historyArray = nil;
    self.chatArray    = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    [self.keyboardView removeAllSubviews];
    [self.keyboardView removeFromSuperview];
    self.keyboardView   = nil;
}
#pragma mark - 清除所有消息记录的通知
- (void)removeAllMessages:(NSNotification*)noti
{
    [self.historyArray removeAllObjects];
    [self.chatArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - UserChatCellProtocol
/**
 *  点击了图片消息的气泡
 *
 *  @param cell   cell
 *  @param index  图片的索引
 */
- (void)userChatImageCell:(UserChatImageCell *)cell didSelectImageAtIndexPath:(NSInteger)index
{
    ChatBaseFrame *frame = [self.chatArray objectAtIndex:index];
    NSURL         *url   = [NSURL URLWithString:frame.chatMessage.messagebodies.remotePath];
    if (!url) {
        url              = [NSURL fileURLWithPath:frame.chatMessage.messagebodies.localPath];
    }
    // 模型
    MJPhoto *photo = [[MJPhoto alloc]init];
    photo.url = url;
    photo.srcImageView = cell.bubbleView;
    photo.image = [UIImage imageNamed:@""];
    // 浏览器
    MJPhotoBrowser *brower2 = [[MJPhotoBrowser alloc]init];
    brower2.photos = @[photo];
    brower2.currentPhotoIndex = 0;
    [brower2 show];
}
@end
