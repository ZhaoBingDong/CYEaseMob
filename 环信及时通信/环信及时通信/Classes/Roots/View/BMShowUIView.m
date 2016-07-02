//
//  BMShowUIView.m
//  环信及时通信
//
//  Created by dabing on 15/10/12.
//  Copyright © 2015年 大兵布莱恩特. All rights reserved.
//

#import "BMShowUIView.h"
#import "CustomButton.h"
@interface BMShowUIView()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**
 *  选择照相机和相册后的回调
 */
@property(nonatomic,copy)void(^imagePickComplete)(UIImage*image,NSDictionary *info);
@end
@implementation BMShowUIView
/**
 *  类方法创建实例
 *
 *  @return 返回一个单例
 */
+(instancetype)shareBmShowView
{
    return [[super alloc] init];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static BMShowUIView *_showView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _showView  = [super allocWithZone:zone];
        _showView.canShowView = YES;
        [[NSNotificationCenter defaultCenter]addObserver:_showView selector:@selector(didRemoveFromSuperView:) name:@"removeFromSuperView" object:nil];
    });
    return _showView;
}
#pragma mark - showActionSheet
/**
 *  类方法创建一个 BMActionSheet 的实例
 *
 *  @param title                  标题
 *  @param cancelButtonTitle      取消按钮
 *  @param destructiveButtonTitle 删除或者红色按钮的标题
 *  @param otherButtonTitles      其他按钮 可以有多个 必须放数组里边
 *  @param view                   显示是视图 不存在加载到 window 上边
 *  @param comBlcok               点击了按钮后的回调
 *
 *  @return 返回一个 BMActionSheet 的单例
 */
+ (instancetype)showActionSheetTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles showInView:(UIView*)view comBlock:(void(^)(NSInteger buttonIndex))comBlcok;
{
    BMShowUIView *showView = [BMShowUIView shareBmShowView];
    showView.completeBlock = comBlcok;
    // 避免多次弹出 actionSheet
    if (showView.canShowView==NO) {
        return showView;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:showView cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil, nil];
    for (NSString *otherTitle in otherButtonTitles) {
        [actionSheet addButtonWithTitle:otherTitle];
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    if (view==nil) {
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    [actionSheet showInView:view];
    return showView;
}
/**
 *  点击了 actionSheet 的按钮
 *
 *  @param actionSheet  actionSheet
 *  @param buttonIndex  按钮索引
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.completeBlock)
    {
        self.completeBlock(buttonIndex);
    }
}
/**
 *  actionSheet 要消失了
 *
 *  @param actionSheet  actionSheet
 *  @param buttonIndex  按钮索引
 */
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.canShowView = YES;
}
/**
 *  actionSheet 将要显示了
 *
 *  @param actionSheet  actionSheet
 */
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    self.canShowView = NO;
}
#pragma mark - showUIbutton

+ (UIButton*)showButtonWithTitle:(NSString*)title rect:(CGRect)rect comBlock:(void(^)(UIButton *button))selector

{
    BMShowUIView *showView = [BMShowUIView shareBmShowView];
    
    UIButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:rect];
    [button addTarget:showView action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [BMShowUIView shareBmShowView].button   = button;
    showView.selector = selector;
    return button;
}

- (void)buttonClick:(UIButton*)btn
{
    if (self.selector) {
        self.selector(btn);
    }
}
#pragma mark - showUIAlertView
/**
 *  类方法创建一个 BMAlertView 的实例
 *
 *  @param title             标题
 *  @param message           消息
 *  @param cancelButtonTitle 取消按钮
 *  @param otherButtonTitles 其他按钮可以有多个,放到数组里 @[@"ss",@"sss"]
 *  @param comBlcok          点击了按钮的回调 默认 取消不回调
 *
 *  @return 返回一个 BMAlertView 的实例
 */
+(instancetype)showUIAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles comBlock:(void(^)(NSInteger buttonIndex))comBlcok
{
    BMShowUIView *showView = [BMShowUIView shareBmShowView];
    if (showView.canShowView == NO) {
        return showView;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:showView cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil, nil];
    for (NSString *string in otherButtonTitles) {
        [alert addButtonWithTitle:string];
    }
    [alert show];
    showView.completeBlock     = comBlcok;
    showView.canShowView = NO;
    return showView;
}
/**
 *  alertView即将消失了
 *
 *  @param alertView    alertView
 *  @param buttonIndex  按钮的索引
 */
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.canShowView = YES;
    if (self.completeBlock) {
        self.completeBlock(buttonIndex);
    }
}

#pragma mark - 监听按钮被销毁的通知

- (void)didRemoveFromSuperView:(NSNotification*)noit
{
    self.button = nil;
}

#pragma mark - 弹出一个照片选择器
/**
 *  弹出一个照片选择器
 *
 *  @param complete 结束后的回调
 *
 *  @return 返回一个 UIImagePickerViewController
 */
+ (UIImagePickerController*)showImagePickerViewControllerInViewControler:(UIViewController*)viewController sourceType:(ImagePickerViewControllerSourceType)type completeBlock:(void(^)(UIImage *image,id infoDict))complete
{
    BMShowUIView *showView = [BMShowUIView shareBmShowView];

    UIImagePickerControllerSourceType sourceType = 0;
    if (type == ImagePickerViewControllerCamera) {
        
        BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (!isCameraSupport) {
            [self showUIAlertViewWithTitle:@"提示" message:@"无法打开手机摄像头" cancelButtonTitle:@"好" otherButtonTitles: nil comBlock:nil];
            return nil;
        }
        sourceType            =   UIImagePickerControllerSourceTypeCamera;
    }
    
    UIImagePickerController *pic = [[UIImagePickerController alloc] init];
    if (type == ImagePickerViewControllerPhotoLibrary) {
        sourceType            =UIImagePickerControllerSourceTypePhotoLibrary;
    }
    pic.sourceType               = sourceType;
    pic.delegate                 = showView;
    pic.allowsEditing = YES;
    [viewController presentViewController:pic animated:YES completion:nil];
    showView.imagePickComplete   = complete;
    return nil;
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    typeof(self)weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[@"UIImagePickerControllerEditedImage"];
        if (weakSelf.imagePickComplete) {
            weakSelf.imagePickComplete(image,info);
        }
    }];
}
/**
 *  imagePick点击了取消
 *
 *  @param picker  pick
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    typeof(self)weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.imagePickComplete) {
            weakSelf.imagePickComplete(nil,nil);
        }
    }];
   
}
@end
