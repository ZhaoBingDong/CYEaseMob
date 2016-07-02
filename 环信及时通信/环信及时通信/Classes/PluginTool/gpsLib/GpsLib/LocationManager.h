//
//  LoacationManager.h
//  定位
//
//  Created by yons on 15/5/1.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@class Placemark;


@interface LocationManager : NSObject<CLLocationManagerDelegate>

// 类方法创建实例
+(instancetype)loactionManager;


/// 经纬度
@property(nonatomic,unsafe_unretained) CLLocationCoordinate2D  coordinate2D;
/// 地理反编译的类
@property (nonatomic, strong) CLGeocoder *geocoder;
/// 位置信息的类
@property (nonatomic,strong) CLLocation   *location;
/// 地理位置反编译结果的类
@property(nonatomic,strong) Placemark    *mark;

// 定位成功的回调
@property(nonatomic,copy) void(^sucessBlock)(Placemark *mark);

// 定位失败的回调

@property(nonatomic,copy) void(^faildBlock)(NSError *error);

// 开启定位
-(void)startLocation;

// 停止定位

-(void)stopLocation;

@end
