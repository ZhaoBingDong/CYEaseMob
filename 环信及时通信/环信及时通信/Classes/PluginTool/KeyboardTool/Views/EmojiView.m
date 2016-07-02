//
//  EmojiView.m
//  DataSource
//
//  Created by yons on 15/6/20.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "EmojiView.h"
#import "EmojiViewCell.h"
@interface EmojiView ()

// indexPath的数组
@property (strong, nonatomic) NSMutableArray *indexPaths;
// 列数
@property (assign, nonatomic) NSInteger columnNumbers;

@end

@implementation EmojiView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
#pragma mark - 使用UIView的frame的Setter方法
// 此方法是在重新调整视图大小时调用的，可以利用此方法在横竖屏切换时刷新数据使用
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}
/**
 *  多少列
 *
 *  @return 列
 */
- (NSInteger)columnNumbers
{
    NSInteger number = 1;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterFlowView:)])
    {
        number = [self.dataSource numberOfColumnsInWaterFlowView:self];
    }
    _columnNumbers = number;
    return _columnNumbers;
}
/**
 *  多少行
 *
 *  @return 行数
 */
-(NSInteger)getSections
{
    return [self.dataSource emojiView:self numberOfRowsInRows:0];
}

- (void)reloadDatas
{
    NSInteger count = [self getSections];
    if (count==0)
    {
        return;
    }
    // 设置 UI 界面
    [self resetView];
}
#pragma mark - 布局视图
// 根据视图属性或数据源方法，生成瀑布流视图界面
- (void)resetView
{
    // 表情总数
    NSInteger dataCount = [self.dataSource numberOfItemsInEmojiView:self];
    // 列数
    NSInteger columnNumber =   [self columnNumbers];
    // 行数
    NSInteger rowCount = [self getSections];
    // 页数
    long long pageCount = (dataCount+(rowCount*columnNumber-1))/(rowCount*columnNumber);
    if (self.indexPaths == nil)
    {
        self.indexPaths = [NSMutableArray arrayWithCapacity:dataCount];
    }
    else
    {
        [self.indexPaths removeAllObjects];
    }
    CGFloat y      = 0.0f;
    CGFloat width  = 0.0f;
    CGFloat height = 0.0f;
    CGFloat x      = 0.0f;
    CGFloat space  = 0.0f;
    // 分页控件
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [self.selfView bottom], DEF_SCREEN_WIDTH, 30)];
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.hidden = YES;
    [self.selfView addSubview:self.pageControl];
    
    // 删除按钮
     self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn  setImage:[UIImage imageNamed:@"DeleteEmoticonBtn@2x.png"] forState:UIControlStateNormal];
    [self.deleteBtn  setFrame:CGRectMake(DEF_SCREEN_WIDTH-60, [self.selfView bottom], 50, 30)];
    [self.deleteBtn setHidden:YES];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.selfView addSubview:self.deleteBtn ];
    // 给每个表情设置一个 tag 将来通过这个 tag 找到这个表情对应的图片
    static int tag = 0;
    // 创建表情
    for (NSInteger i = 0; i < pageCount; i++)
    {
        // 放表情的背景
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
        [self addSubview:bgView];
        for (int j =0; j<rowCount*columnNumber; j++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
            [self.indexPaths addObject:indexPath];
            EmojiViewCell *cell = nil;
            if ([self.dataSource respondsToSelector:@selector(emojiView:cellForRowAtIndexPath:)])
            {
                cell = [self.dataSource emojiView:self cellForRowAtIndexPath:indexPath];
                [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
                cell.tag = tag;
            }
            //得到宽 和 高
            width = [self.mydelegate emojiView:self widthForRowAtIndexPath:indexPath];
            
            height= [self.mydelegate emojiView:self heigthForRowAtIndexPath:indexPath];
            //间隔
            space = (self.bounds.size.width-width*columnNumber)/(columnNumber+1);
            // x 和 y 的坐标
            x   = space+(width+space)*(j%columnNumber);
            y   = space+(height+space)*(j/columnNumber);
            
            // 放表情的背景 view
            [cell setFrame:CGRectMake(x,y, width, height)];
            [bgView addSubview:cell];
            [bgView setFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, y+space+height)];
            
            if (tag<dataCount-1)
            {
                [cell setNeedsLayout];
                tag++;
            }
            else
            {
                [cell removeFromSuperview];
            }
        }
    }
    // tag 置为0 以后刷新时重新从0开始布局
    tag = 0;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, y+height+space)];
  
    [self setContentSize:CGSizeMake(self.frame.size.width*pageCount, self.frame.size.height)];
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    
}
/**
 *  点击了表情图片
 */
- (void)tapClick:(UITapGestureRecognizer*)tapView
{
    NSIndexPath *indexPath = self.indexPaths[tapView.view.tag];
    if ([self.mydelegate respondsToSelector:@selector(emojiView:didSelectRowAtIndexPath:)])
    {
        [self.mydelegate emojiView:self didSelectRowAtIndexPath:indexPath];
    }
}

/**
 *  展示
 */
-(void)showWithKeyboard:(KeyboardView*)emojiView
{
    self.pageControl.hidden = NO;
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        [emojiView setFrame:CGRectMake(0, DEF_SCREEN_HEIGHT-50-217, DEF_SCREEN_WIDTH, 50)];
        [self setFrame:CGRectMake(0, DEF_SCREEN_HEIGHT-217, DEF_SCREEN_WIDTH, 217)];
    }];
}
/**
 *  隐藏
 */
-(void)hiddenWithKeyboard:(KeyboardView*)emojiView
{
    self.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        [self setFrame:CGRectMake(0, DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, 217)];
        [emojiView setFrame:CGRectMake(0, DEF_SCREEN_HEIGHT-50, DEF_SCREEN_WIDTH, 50)];
    }];
}
#pragma mark -  监听 view 的 frame 绝对是否显示 pageControl
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    EmojiView *emojiView =(EmojiView*)object;
    CGFloat screenHeight = DEF_SCREEN_HEIGHT;
    if (screenHeight>emojiView.frame.origin.y)
    {
        self.pageControl.hidden =NO;
        self.pageControl.frame = CGRectMake(0, [self.selfView bottom]-40, DEF_SCREEN_WIDTH, 30);
        [self.deleteBtn setHidden:NO];
        [self.deleteBtn setFrame:CGRectMake(DEF_SCREEN_WIDTH-60, [self.selfView bottom]-40, 50, 40)];
    }
    else if (emojiView.frame.origin.y<=DEF_SCREEN_HEIGHT)
    {
        self.pageControl.hidden = YES;
        self.pageControl.frame = CGRectMake(0, [self.selfView bottom], DEF_SCREEN_WIDTH, 30);
        [self.deleteBtn setHidden:YES];
        [self.deleteBtn setFrame:CGRectMake(DEF_SCREEN_WIDTH-60, [self.selfView bottom], 50, 40)];
    }
}
/**
 *  传进来的输入框
 *
 *  @param textField 输入框
 */
- (void)setTextField:(UITextField *)textField
{
    _textField  = textField;
}
/// 删除的按钮
- (void)deleteBtnClick:(UIButton*)deleteBtn
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:self.textField.text];
    NSArray *array = [HMDatabaseTool getHMResult:str];
    // 拿到最后一个结果集 判断是不是表情 如果是就把表情删除
    HMResult *reslut = [array lastObject];
    if (reslut)
    {
        if (reslut.isEmotion)
        {
            [str deleteCharactersInRange:reslut.range];
        }
    }
    self.textField.text = str;
    if ([self.mydelegate respondsToSelector:@selector(emojiView:deleteTextByRange:)]) {
        [self.mydelegate emojiView:self deleteTextByRange:reslut.range];
    }
}
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame" context:nil];
}

@end
