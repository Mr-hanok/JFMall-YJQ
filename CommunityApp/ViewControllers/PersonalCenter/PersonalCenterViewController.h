//
//  PersonalCenterViewController.h
//  CommunityApp
//
//  Created by issuser on 15/6/2.
//  Copyright (c) 2015年 iss. All rights reserved.
//
//
#import "BaseViewController.h"
//路址判断🍎
#import "RoadData.h"

@interface PersonalCenterViewController : BaseViewController
@property (nonatomic, retain) UIViewController *backVC;

@property (nonatomic, assign) BOOL  isRootVC;
@property (nonatomic, retain) UIImage   *myAvatar;
//🍎

@property (weak, nonatomic) IBOutlet UIView *weixinview;

@property (weak, nonatomic) IBOutlet UIView *otherview;
@property (strong,nonatomic) RoadData* roadData;

//+(void)initBasicDataInfo;
@end
