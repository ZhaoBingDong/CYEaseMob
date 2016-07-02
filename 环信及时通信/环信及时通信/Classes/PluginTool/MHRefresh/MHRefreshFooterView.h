//
//  MHRefreshFooterView.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/13.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

/**
 *  底部view
 */

#import "MHRefreshBaseView.h"

@interface MHRefreshFooterView : MHRefreshBaseView

// 记录刷新前的数量
@property (assign, nonatomic) NSInteger lastRefreshCount;

+ (instancetype)footer;

@end
