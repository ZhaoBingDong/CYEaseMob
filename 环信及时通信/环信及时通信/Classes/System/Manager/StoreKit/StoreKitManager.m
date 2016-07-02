//
//  StoreKitManager.m
//  MHProject
//
//  Created by MengHuan on 15/5/13.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "StoreKitManager.h"

@implementation StoreKitManager

+ (StoreKitManager *)sharedStoreKitManager
{
    static StoreKitManager *skManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        skManager = [[self alloc] init];
    });
    return skManager;
}


#pragma mark - 初始化App内购
- (void)initStoreKit
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

#pragma mark - 购买产品
- (void)purchaseItem:(NSString *)identifier
{
    [self showLoadingHUDByMsg:@"访问商店..."];
    
    // 检查是否可以处理付款
    if (![SKPaymentQueue canMakePayments])
    {
        NSLog(@"1.不能处理付款-->SKPaymentQueue canMakePayments NO");
        
        [self hideLoadingHUDByMsg:@"商店访问失败，请重试..." afterDelay:2];
        
        return;
    }
    
    NSLog(@"1.可以处理付款-->请求产品信息...%@", identifier);
    
    // 使用请求商品信息式购买
    SKProductsRequest *request  = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:identifier]];
    request.delegate            = self;
    [request start];
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *myProduct = response.products;
    
    NSLog(@"myProduct: %@", myProduct);
    
    if (myProduct.count == 0)
    {
        NSLog(@"2.失败-->无法获取产品信息，购买失败。invalidProductIdentifiers = %@", response.invalidProductIdentifiers);
        
        [self hideLoadingHUDByMsg:@"购买失败，请重试..." afterDelay:2];
        
        return;
    }
    
    NSLog(@"2.成功-->获取产品信息成功，正在购买...");
    
    // 这里隐藏alertview
    [self hideLoadingHUD];
    
    SKPayment *payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKPaymentQueue的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"3.成功-->接收苹果购买数据，正在处理...");
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
            {
                [self completeTransaction:transaction];
            }
                break;
                
            case SKPaymentTransactionStateFailed:
            {
                [self failedTransaction:transaction];
            }
                break;
                
            case SKPaymentTransactionStateRestored:
            {
                [self restoreTransaction:transaction];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 结束交易
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"4.成功-->结束交易 SKPaymentTransactionStatePurchased");
    
    // 记录交易和提供产品 这个方法必须处理
    [self recordTransaction:transaction identifier:transaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - 重置交易
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"4.成功-->重置交易 SKPaymentTransactionStateRestored");
    
    [self recordTransaction:transaction identifier:transaction.originalTransaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"4.成功-->交易失败 SKPaymentTransactionStateRestored error.code:%d",(int)transaction.error.code);
    
    [self hideLoadingHUDByMsg:@"购买失败，请重试..." afterDelay:2];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - 记录交易和提供产品
- (void)recordTransaction:(SKPaymentTransaction *)transacation identifier:(NSString *)identifier
{
    NSLog(@"4.成功-->交易成功:\n请提供产品 identifier = %@\n交易记录，可以在此处存储记录", identifier);
    
    [self hideLoadingHUDByMsg:@"恭喜，您已成功购买" afterDelay:2];
    
    // block回到控制器去处理...
    if (self.storeKitSuccessBlock)
    {
        self.storeKitSuccessBlock(transacation, identifier);
    }
}


#pragma mark - 数据请求中loading
- (void)showLoadingHUDByMsg:(NSString *)msg
{
    loadingAlertView= [[UIAlertView alloc] initWithTitle:nil
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:nil
                                       otherButtonTitles:nil, nil];
    [loadingAlertView show];
}

- (void)hideLoadingHUD
{
    [loadingAlertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)hideLoadingHUDByMsg:(NSString *)msg afterDelay:(NSTimeInterval)delay
{
    [self hideLoadingHUD];
    [self showLoadingHUDByMsg:msg];
    
    // delay秒之后关闭loading
    [self performSelector:@selector(hideLoadingHUD) withObject:nil afterDelay:delay];
}

@end
