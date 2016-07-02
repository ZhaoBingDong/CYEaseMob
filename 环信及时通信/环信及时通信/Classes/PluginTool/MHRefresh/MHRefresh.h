//
//  MHRefresh.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/13.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "UIScrollView+MHRefresh.h"

/**
 *  1, 添加头部控件的方法    // collectionView方式一样
 *  [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
 *  或者
 *  [self.tableView addHeaderWithCallback:^{ }];
 *
 *  2, 添加尾部控件的方法    // collectionView方式一样
 *  [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
 *  或者
 *  [self.tableView addFooterWithCallback:^{ }];
 *
 *  __unsafe_unretained 防止block循环引用
 *  
 *  __unsafe_unretained typeof(self) vc = self;
 *  [self.tableView addFooterWithCallback:^{ 
 *      [vc 方法];
 *  }];
 *
 *  3, 可以在MHRefreshConst.h和MHRefreshConst.m文件中自定义显示的文字内容和文字颜色，在MHRefreshBaseView里添加自定义等待view(图片，动画，等)
 *
 *  4, 本框架兼容iOS6\iOS7，iPhone\iPad横竖屏
 *
 *  5, 自动刷新:
 *  1> [self.tableView headerBeginRefreshing];
 *  2> [self.tableView footerBeginRefreshing];
 *
 *  6, 结束刷新:
 *  1> [self.tableView headerEndRefreshing];
 *  2> [self.tableView footerEndRefreshing];
 */
