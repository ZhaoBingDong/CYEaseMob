//
//  WGS84TOGCJ02.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/21.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WGS84TOGCJ02 : NSObject

// 转火星坐标

+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc ;


//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;


@end