//
//  BaiduMapViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/7/23.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaiduMapViewController.h"

@interface BaiduMapViewController ()

@end

@implementation BaiduMapViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    // 导航栏初始化
//    self.navigationItem.title = @"查看地图";
//    [self setNavBarLeftItemAsBackArrow];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    _mapView.delegate = self;
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    // 添加一个PointAnnotation
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    if (self.addr != nil) {
////        NSString *strLatitude = [NSString stringWithFormat:@"%.3f", self.addr.latitude];
////        NSString *strLongitude = [NSString stringWithFormat:@"%.3f", self.addr.longitude];
////        coor.latitude = [strLatitude floatValue];
////        coor.longitude = [strLongitude floatValue];
//        coor.latitude = 31.14;
//        coor.longitude = 121.29;
//        annotation.title = self.addr.addrName;
//    }else {
//        coor.latitude = 39.915;
//        coor.longitude = 116.404;
//        annotation.title = @"默认地址";
//    }
//    annotation.coordinate = coor;
//    [_mapView addAnnotation:annotation];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    _mapView.delegate = nil;
//}
//
//
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
//        return newAnnotationView;
//    }
//    return nil;
//}
//
//
//
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}



@end
