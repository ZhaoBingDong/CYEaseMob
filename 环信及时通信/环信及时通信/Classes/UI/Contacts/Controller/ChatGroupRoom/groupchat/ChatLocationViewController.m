//
//  ChatLocationViewController.m
//  环信及时通信
//
//  Created by yons on 15/10/12.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ChatLocationViewController.h"
#import "ChatGroupRoomViewController.h"
#import "MyAnnation.h"
#import "LocationManager.h"
#import "Placemark.h"
@interface ChatLocationViewController ()
<MKMapViewDelegate,CLLocationManagerDelegate>
/// 定位管理者对象
@property(nonatomic,strong)CLLocationManager *manager;
@property(nonatomic,strong)NSMutableArray    *anns;
@end

@implementation ChatLocationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    self.title  = @"位置信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendLocation)];
    self.manager = [[CLLocationManager alloc] init];
    self.manager.distanceFilter  = 10.0f;
    [self.manager requestAlwaysAuthorization];
    [self.manager requestWhenInUseAuthorization];
    self.manager.delegate       = self;
    [self.manager startUpdatingLocation];
    /// 开启定位功能
    TYPEWEAKSELF;
    [[LocationManager loactionManager]startLocation];
    [[LocationManager loactionManager]setSucessBlock:^(Placemark *place)
     {
         [weakSelf.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(place.location.latitude, place.location.longitude), MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
         [weakSelf.mapView removeAnnotations:weakSelf.anns];
         [weakSelf.anns removeAllObjects];
         MyAnnation  *ann = [[MyAnnation alloc] init];
         ann.title = @"我在这里";
         ann.coordinate = place.location;
         [weakSelf.anns addObject:ann];
         [weakSelf.mapView addAnnotations:weakSelf.anns];
     }];
}
- (NSMutableArray *)anns
{
    if (!_anns) {
        _anns = [NSMutableArray array];
    }
    return _anns;
}
- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView            = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64)];
        _mapView.delegate   = self;
        _mapView.showsUserLocation = YES;
        _mapView.userLocation.title = @"help me";
        _mapView.userLocation.subtitle = @"快来救我啊";
        _mapView.mapType = MKMapTypeStandard;
    }
    return _mapView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.mapView.delegate   = nil;
    self.manager.delegate   = nil;
    self.manager            = nil;
    [self.mapView removeAnnotations:self.anns];
    self.mapView            = nil;
}

#pragma mark - 发送位置

- (void)sendLocation
{
    LocationManager *locatioManager = [LocationManager loactionManager];
    [self.navigationController popViewControllerAnimated:YES];
    // 获取上一个控制器
    ChatGroupRoomViewController *roomVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [roomVC sendLocationMessageBy:locatioManager.mark];
}
/// 定位成功后的代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
}

- (void)dealloc
{
    [self.anns removeAllObjects];
    NSLog(@"======");
}
@end
