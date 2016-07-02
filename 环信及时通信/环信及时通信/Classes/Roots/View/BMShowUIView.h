//
//  BMShowUIView.h
//  环信及时通信
//
//  Created by dabing on 15/10/12.
//  Copyright © 2015年 大兵布莱恩特. All rights reserved.
//

typedef NS_ENUM(NSInteger, ImagePickerViewControllerSourceType) {
    ImagePickerViewControllerPhotoLibrary = 1,  //相册
    ImagePickerViewControllerCamera       = 2   //相机
};

#import <Foundation/Foundation.h>

/**
 *  用来显示各种 UIView 的目前支持 UIActionSheet 和 UIAlertView UIButton 
 */
@interface BMShowUIView : NSObject
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
/**
 *  显示一个按钮
 *
 *  @param title        标题
 *  @param rect         rect
 *  @param selector     绑定事件
 *
 *  @return 返回一个按钮
 */
+ (UIButton*)showButtonWithTitle:(NSString*)title rect:(CGRect)rect comBlock:(void(^)(UIButton *button))selector;

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
+(instancetype)showUIAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles comBlock:(void(^)(NSInteger buttonIndex))comBlcok;

/**
 *  completeBlock
 */
@property(nonatomic,copy) void(^completeBlock)(NSInteger index);
/**
 *   是否能再次弹出一个 view;
 */
@property(nonatomic,assign)BOOL canShowView;
/**
 *  内部引用一个按钮 用来保存这个按钮
 */
@property(nonatomic,strong)UIButton *button;
/**
 *  点击按钮后的回调方法
 */
@property(nonatomic,copy) void(^selector)(id sender);
/**
 *  弹出一个照片选择器
 *
 *  @param complete 结束后的回调
 *
 *  @return 返回一个 UIImagePickerViewController
 */
+ (UIImagePickerController*)showImagePickerViewControllerInViewControler:(UIViewController*)viewController sourceType:(ImagePickerViewControllerSourceType)type completeBlock:(void(^)(UIImage *image,id infoDict))complete;

@end
