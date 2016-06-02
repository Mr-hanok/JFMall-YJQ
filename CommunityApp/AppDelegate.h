//
//  AppDelegate.h
//  CommunityApp
//
//  Created by issuser on 15/6/2.
//  Copyright (c) 2015年 iss. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <FMDB.h>
#import "PersonalCenterViewController.h"
#import "MainViewController.h"
@protocol AppBaseViewDelegate<NSObject>
@optional
-(void)toLogin;
@end
@interface AppDelegate : UIResponder <UIApplicationDelegate,/*ISSShareViewDelegate,*/ UIAlertViewDelegate>
{
//    BMKMapManager* _mapManager;
}

@property (assign,nonatomic) id<AppBaseViewDelegate>baseViewDelegate;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSMutableArray* userArray;
@property (nonatomic, retain) FMDatabase *db;
@property (nonatomic, assign) BOOL isWillLogin;
@property (nonatomic, retain)id chatDelegate;
@property (nonatomic, retain)id messageDelegate;
@property (nonatomic, copy) void(^userAccountLoginAtOtherPlaceBlock)(BOOL);
@property (nonatomic, copy) void(^wxPayOKtoDo)(BOOL);

-(void)loadSWRevealViewController;

@end
