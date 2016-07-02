//
//  MHRefreshHeaderView.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/13.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

/**
 *  头部view
 */

#import "MHRefreshBaseView.h"

@interface MHRefreshHeaderView : MHRefreshBaseView

@property (nonatomic, copy) NSString *dateKey;

+ (instancetype)header;

@end
