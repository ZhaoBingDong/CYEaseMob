//
//  MyAnnation.h
//  PerfectProject
//
//  Created by yons on 15/6/14.
//  Copyright (c) 2015年 M.H Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnation : NSObject<MKAnnotation>

@property (nonatomic,copy)NSString  *title;

@property(nonatomic,copy)NSString  *subTitle;

@property(nonatomic,copy)NSString  *image;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;



@end
