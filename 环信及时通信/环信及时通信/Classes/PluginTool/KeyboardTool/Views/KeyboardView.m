//
//  KeyboardView.m
//  DataSource
//
//  Created by yons on 15/6/21.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "KeyboardView.h"
#import "MyButton.h"
#import "EmojiViewCell.h"

@interface KeyboardView ()
<
EmojiViewDataSource,
EmojiViewDelegate,
UITextFieldDelegate,
UIScrollViewDelegate
>
{
    // 录音时间
    int timeSecond;
}
/**
 *  mutableString
 */
@property(nonatomic,copy)NSMutableString   *mutableAttributedString;

@property(nonatomic,strong)NSTimer    *timer;

@end

@implementation KeyboardView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        self.clipsToBounds = YES;
        
        self.backgroundColor = [[UIColor colorWithWhite:0.91 alpha:1]colorWithAlphaComponent:0.9];
        // 左边语音的按钮
        self.voiceBtn = [MyButton buttonWithType:UIButtonTypeCustom];
        [self.voiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [self.voiceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
        [self.voiceBtn setFrame:CGRectMake(5, 0, 30, frame.size.height)];
        [self.voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.voiceBtn];
        //添加的按钮
        self.addBtn = [MyButton buttonWithType:UIButtonTypeCustom];
        [self.addBtn setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [self.addBtn setFrame:CGRectMake(DEF_SCREEN_WIDTH-35, 0, 30, frame.size.height)];
        [self.addBtn addTarget:self action:@selector(addImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addBtn];
        // 表情的按钮
        self.faceBtn = [MyButton buttonWithType:UIButtonTypeCustom];
        [self.faceBtn setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [self.faceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
        [self.faceBtn setFrame:CGRectMake([self.addBtn left]-32, 0, 30, frame.size.height)];
        [self.faceBtn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.faceBtn];
        // 输入框的宽度
        CGFloat width = DEF_SCREEN_WIDTH-[self.voiceBtn right]-77;
        
        // 中间输入框
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake([self.voiceBtn right]+5, 5,width, frame.size.height-10)];
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeySend;
        [self addSubview:self.textField];
        
        // 监听键盘打开 和关闭
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.array = [HMDatabaseTool getemojis];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
        {
            [self.emojiView reloadDatas];
            [self.emojiView.pageControl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:UIControlEventValueChanged];
        });
        
        // 发语音的按钮
        self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.recordBtn setTitle:@"按住不动开始录音" forState:UIControlStateNormal];
        [self.recordBtn setFrame:self.textField.frame];
        [self.recordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.recordBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.recordBtn];
        self.recordBtn.backgroundColor = [UIColor whiteColor];
        [self.recordBtn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.recordBtn addTarget:self action:@selector(longTapClick:) forControlEvents:UIControlEventTouchDown];
        self.recordBtn.layer.cornerRadius =3;
        self.recordBtn.layer.masksToBounds = YES;
        self.recordBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.recordBtn.layer.borderWidth = 0.5;
        [self.recordBtn setHidden:YES];
        // 录音时长
        timeSecond  = 0;
        // 监听自身 frame 的改变
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
    }
    return self;
}
/// 手指松开或者结束录音
- (void)recordBtnClick:(UIButton*)recordBtn
{
    recordBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    [recordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.recordBtn setTitle:@"按住不动开始录音" forState:UIControlStateNormal];
    if ([self.mydelegate respondsToSelector:@selector(keyboardViewDidEndRocord:)]) {
        [self.mydelegate keyboardViewDidEndRocord:nil];
    }
}
/// 开始录音
- (void)longTapClick:(UIButton*)longTapBtn
{
    // 改变按钮状态
    longTapBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    [longTapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [longTapBtn setTitle:@"正在录音" forState:UIControlStateNormal];
    if ([self.mydelegate respondsToSelector:@selector(keyboardViewDidStartRecord:)])
    {
        [self.mydelegate keyboardViewDidStartRecord:longTapBtn];
    }
}

#pragma mark - 点击了表情的按钮

-(void)addImageClick:(MyButton*)addBtn
{
    [self.textField resignFirstResponder];
    [self.voiceBtn setSelected:NO];
    [self.faceBtn setSelected:NO];
    self.textField.hidden = NO;
    self.textField.text = @"";
    [self.recordBtn setHidden:YES];
    [UIView animateWithDuration:0.25 animations:^
    {
        [self.emojiView setY:DEF_SCREEN_HEIGHT];
        [self setY:DEF_SCREEN_HEIGHT-50];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        // 告诉控制器打开相册或者相机
        if ([self.mydelegate respondsToSelector:@selector(keyboardViewDidSendImageView)])
        {
            [self.mydelegate keyboardViewDidSendImageView];
        }
    });
}

#pragma mark - 点击了录音的按钮

- (void)voiceBtnClick:(MyButton*)voiceBtn
{
    voiceBtn.selected =!voiceBtn.selected;
    if (voiceBtn.selected)
    {
        self.recordBtn.hidden = NO;
        [self.textField resignFirstResponder];
        self.textField.hidden = YES;
        self.textField.text = @"";
        [UIView animateWithDuration:0.25 animations:^
        {
            [self.emojiView setY:DEF_SCREEN_HEIGHT];
            [self setY:DEF_SCREEN_HEIGHT-50];
        }];
    }else
    {
        [self.textField becomeFirstResponder];
        self.recordBtn.hidden = YES;
        self.textField.hidden = NO;
    }
}

///可变的 attributedString
-(NSMutableString*)mutableAttributedString
{
    if (!_mutableAttributedString)
    {
        _mutableAttributedString = [[NSMutableString alloc] initWithString:@""];
    }
    return _mutableAttributedString;
}
/// 表情键盘
-(EmojiView*)emojiView
{
    if (!_emojiView)
    {
        // 表情键盘
        _emojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0,DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, 217)];
        _emojiView.mydelegate = self;
        _emojiView.dataSource = self;
        _emojiView.delegate   = self;
        _emojiView.selfView   = self.selfSuperView;
        _emojiView.textField  = self.textField;
        [self.selfSuperView addSubview:_emojiView];
    }
    
    return _emojiView;
}
#pragma mark -  添加表情的按钮

- (void)faceBtnClick:(MyButton*)faceBtn
{
    faceBtn.selected =!faceBtn.selected;
    self.voiceBtn.selected = NO;
    [self.recordBtn setHidden:YES];
    [self.textField setHidden:NO];
    if (faceBtn.selected)
    {
        [self.textField resignFirstResponder];
        [self.emojiView showWithKeyboard:self];
    }
    else
    {
        [self.textField becomeFirstResponder];
        [self.emojiView setY:DEF_SCREEN_HEIGHT];
    
    }
}

#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^
     {
         [self setFrame:CGRectMake(self.frame.origin.x,DEF_SCREEN_HEIGHT-ty-self.frame.size.height, self.frame.size.width, self.frame.size.height)];
         [self.emojiView setFrame:CGRectMake(0, DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, 217)];
     }completion:nil];
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^
     {
          [self setFrame:CGRectMake(self.frame.origin.x,DEF_SCREEN_HEIGHT-50, self.frame.size.width, self.frame.size.height)];
     }];
}
/**
 *  表情总数量
 *
 *  @param emojiView 表情的视图
 *
 *  @return 返回表情数量
 */
- (NSInteger)numberOfItemsInEmojiView:(EmojiView *)emojiView
{
    return self.array.count;
}
/**
 *  列数
 *
 *  @param emojiview
 *
 *  @return 列数
 */
- (NSInteger)numberOfColumnsInWaterFlowView:(EmojiView *)emojiview
{
    return 8;
}
/**
 *  行数
 *
 *  @param emojiView emojiView
 *  @param rows      行数
 *
 *  @return 行数
 */

- (NSInteger)emojiView:(EmojiView *)emojiView numberOfRowsInRows:(NSInteger)rows
{
    return 4;
}
/**
 *  返回表情
 *
 *  @param emojiView 表情
 *  @param indexPath  indexPath
 *
 *  @return  返回一个表情实例
 */
- (EmojiViewCell*)emojiView:(EmojiView *)emojiView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmojiViewCell *cell = [[EmojiViewCell alloc] init];
    EmojiModel *model =self.array[indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model.key]]];
    return cell;
}
/**
 *  每个表情的宽度
 *
 *  @param emojiView 表情
 *  @param indexPath  indexPath
 *
 *  @return 返回宽度
 */
- (CGFloat)emojiView:(EmojiView *)emojiView heigthForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
/**
 *  每个表情的高度
 *
 *  @param emojiView 表情
 *  @param indexPath 返回 indexPath
 *
 *  @return  返回一个表情的高度
 */
- (CGFloat)emojiView:(EmojiView *)emojiView widthForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (void)emojiView:(EmojiView *)emojiView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击了那个表情
    // 找到那个表情的模型 取出图片名
    EmojiModel *model = [HMDatabaseTool getemojis][indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@",model.value];
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:self.mutableAttributedString];
    [mutableStr appendString:string];
    [self.textField setText:mutableStr];
    self.mutableAttributedString = mutableStr;
}
/**
 *  点击了 emojiview 上边的删除按钮
 *
 *  @param emojiView  emojiview
 *  @param range     range
 */
- (void)emojiView:(EmojiView *)emojiView deleteTextByRange:(NSRange)range
{
    self.mutableAttributedString = [[NSMutableString alloc]initWithString:self.textField.text];
}
#pragma mark - 输入框的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 判断用户是否输入的全部是空格 并且不是 空字符串 就允许发送消息
    if (![textField.text isEqualToString:@""])
    {
        NSMutableString *str = [NSMutableString stringWithString:textField.text];
        while ([str rangeOfString:@" "].location!=NSNotFound)
        {
            [str deleteCharactersInRange:[str rangeOfString:@" "]];
        }
        if ([str length] == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"不能发送空白消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else
        {
            if ([self.mydelegate respondsToSelector:@selector(keyboardViewDidSendMessage:)])
            {
                [self.mydelegate keyboardViewDidSendMessage:textField.text];
            }
            textField.text = @"";
        }
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.voiceBtn setSelected:NO];
    [self.faceBtn setSelected:NO];
    if ([textField.text isEqualToString:@""])
    {
        // 全局的 attributedString 用来拼接输入框的内容
        self.mutableAttributedString = [[NSMutableString alloc] initWithString:@""];
    }
    else
    {
        // 全局的 attributedString 用来拼接输入框的内容
        self.mutableAttributedString = [[NSMutableString alloc] initWithString:textField.text];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.mutableAttributedString = [[NSMutableString alloc] initWithString:textField.text];
}
/**
 *  所有子控件失去第一相应
 */
-(void)allSubviewsResignFirstResponder
{
    // 键盘在底部不需要改变键盘上边控件的显示状态
    if ([self top]== DEF_SCREEN_HEIGHT-50)return;
    [self.textField resignFirstResponder];
    [self.emojiView hiddenWithKeyboard:self];
    [self.voiceBtn setSelected:NO];
    [self.faceBtn setSelected:NO];
    self.textField.text = @"";
}

#pragma mark -  滚动视图的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.emojiView.pageControl.currentPage = scrollView.contentOffset.x/DEF_SCREEN_WIDTH;
}
- (void)pageControlValueChange:(UIPageControl*)page
{
    [self.emojiView setContentOffset:CGPointMake(self.emojiView.pageControl.currentPage*DEF_SCREEN_WIDTH, 0) animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"frame"];
    self.textField.delegate = nil;
    [self.emojiView removeAllSubviews];
    [self.emojiView removeFromSuperview];
    self.emojiView  = nil;
}
#pragma mark -  KVO 观察键盘位置发送改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    KeyboardView *keyboard = self;
    if ([self.mydelegate respondsToSelector:@selector(keyboardViewChangePosition:)])
    {
        [self.mydelegate keyboardViewChangePosition:keyboard.frame.origin.y];
    }
}
@end
