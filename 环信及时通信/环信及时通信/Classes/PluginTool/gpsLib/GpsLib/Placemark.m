//
//  Placemark.m
//  定位
//
//  Created by yons on 15/5/1.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "Placemark.h"

@implementation Placemark

// 字典转模型
-(id)initPlaceModelWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        self.city = dict[@"City"];
        self.country = dict[@"Country"];
        self.countryCode = dict[@"CountryCode"];
        NSArray *array = dict[@"FormattedAddressLines"];
        self.FormattedAddressLines = [array lastObject];
        self.Name = dict[@"Name"];
        self.State = dict[@"State"];
        self.Street = dict[@"Street"];
        self.SubLocality = dict[@"SubLocality"];
        self.SubThoroughfare = dict[@"SubThoroughfare"];
        self.Thoroughfare = dict[@"Thoroughfare"];

    }
    return self;
}

+(instancetype)placeModelWithDictionary:(NSDictionary*)dict
{
    return [[self alloc]initPlaceModelWithDictionary:dict];
}


@end
