//
//  MainViewController.h
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController<UITabBarControllerDelegate>

@property (nonatomic, assign) BOOL  isRootVC;
@property (nonatomic, copy) NSString    *projectId;     //项目(小区）ID
@end
