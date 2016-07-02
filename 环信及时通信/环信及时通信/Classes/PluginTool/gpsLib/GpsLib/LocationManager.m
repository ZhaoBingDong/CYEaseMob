//
//  LoacationManager.m
//  定位
//
//  Created by yons on 15/5/1.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "LocationManager.h"
#import "Placemark.h"
#import "WGS84TOGCJ02.h"

#define IOS8   [UIDevice currentDevice].systemVersion.floatValue>=8.0f

/// 单例对象
static LocationManager *_manager;
/// 定位的管理对象
static CLLocationManager  *_locationManager;

@implementation LocationManager


+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _manager = [super allocWithZone:zone];
    });
    
    return _manager;
}

/// 类方法
+(instancetype)loactionManager
{
    return [[super alloc]init];
}

// 开启定位
-(void)startLocation
{
    
    if (_locationManager==nil)
    {
        _locationManager = [[CLLocationManager alloc]init];
    }
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=10.0f;
    if (IOS8)
    {
        [_locationManager requestWhenInUseAuthorization];

    }
    
    [_locationManager startUpdatingLocation];

}

// 定位成功
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *location = [locations lastObject];
  
    // 转火星坐标
    CLLocationCoordinate2D newCoordinate2D = [WGS84TOGCJ02 transformFromWGSToGCJ:location.coordinate];
    // 地理反编译
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:newCoordinate2D.latitude longitude:newCoordinate2D.longitude];
    // 经纬度坐标
    self.location = newLocation;
    
    // 获得城市名称
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0) return;
        
        CLPlacemark *placemark = [placemarks firstObject];
        NSDictionary *dict = placemark.addressDictionary;
        // 地理反编译
        Placemark *mark = [Placemark placeModelWithDictionary:dict];
        mark.location =  self.location.coordinate;
        self.coordinate2D = mark.location;
        self.mark = mark;
        
        if (self.sucessBlock)
        {
            self.sucessBlock(mark);
        }
        
    }];
}

// 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.faildBlock)
    {
        self.faildBlock(error);
    }
}

- (CLGeocoder *)geocoder
{
    if (_geocoder == nil)
    {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
// 停止定位
-(void)stopLocation
{
    if (_locationManager==nil)
    {
        return;
    }
    [_locationManager stopUpdatingLocation];
}


@end
