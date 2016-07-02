//
//  Placemark.h
//  定位
//
//  Created by yons on 15/5/1.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Placemark : NSObject

/// city
@property(nonatomic,copy)NSString * city;

/// country
@property(nonatomic,copy)NSString * country;

/// countryCode
@property(nonatomic,copy)NSString * countryCode;

/// 地址全名
@property(nonatomic,copy)NSString * FormattedAddressLines;

/// Name
@property(nonatomic,copy)NSString * Name;

/// State
@property(nonatomic,copy)NSString * State;

/// Street
@property(nonatomic,copy)NSString * Street;

/// SubLocality
@property(nonatomic,copy)NSString * SubLocality;

/// SubThoroughfare
@property(nonatomic,copy)NSString * SubThoroughfare;

/// Thoroughfare
@property(nonatomic,copy)NSString * Thoroughfare;
// 经纬度的结构体 
@property(nonatomic,unsafe_unretained)CLLocationCoordinate2D location;

// 字典转模型
-(id)initPlaceModelWithDictionary:(NSDictionary*)dict;


+(instancetype)placeModelWithDictionary:(NSDictionary*)dict;


@end
