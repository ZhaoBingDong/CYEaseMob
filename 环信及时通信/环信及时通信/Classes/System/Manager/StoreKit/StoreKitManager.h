//
//  StoreKitManager.h
//  MHProject
//
//  Created by MengHuan on 15/5/13.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//


/**
// 在viewDidLoad里初始化
[[StoreKitManager sharedStoreKitManager] initStoreKit];

// 在使用的地方
// 防止循环引用
__unsafe_unretained typeof([StoreKitManager sharedStoreKitManager]) sk = [StoreKitManager sharedStoreKitManager];

// 开始购买
[sk purchaseItem:@"苹果开发者后台设置的identifier"];

sk.storeKitSuccessBlock = ^(SKPaymentTransaction *transacation, NSString *identifier) {
    
    // 做自己想做的处理，给相应的奖励...
    
};
 */


/**
 *  Apple 内购
 *
 *  @framework
 *      StoreKit.framework
 */

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface StoreKitManager : NSObject
<
SKPaymentTransactionObserver,
SKProductsRequestDelegate
>
{
    // 数据请求中loading
    UIAlertView *loadingAlertView;
}


/**
 *  单例类
 *
 *  @return StoreKitManager
 */
+ (StoreKitManager *)sharedStoreKitManager;


#pragma mark - 初始化App内购
/**
 *  初始化App内购
 */
- (void)initStoreKit;


#pragma mark - 购买产品
/**
 *  购买产品
 *
 *  @param identifier 产品标示符，苹果开发者后台设置
 */
- (void)purchaseItem:(NSString *)identifier;


#pragma mark - 内购block
/**
 *  内购block
 */
@property (nonatomic, copy) void (^storeKitSuccessBlock)(SKPaymentTransaction *transacation, NSString *identifier);

@end
