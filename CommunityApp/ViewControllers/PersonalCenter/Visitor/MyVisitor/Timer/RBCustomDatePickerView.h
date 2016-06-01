//
//  RBCustomDatePickerView.h
//  RBCustomDateTimePicker
//  e-mail:rbyyy924805@163.com
//  Created by renbing on 3/17/14.
//  Copyright (c) 2014 renbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"
//typedef void(^GvieBlock)(NSString *timeString);

@class giveTimeDelegate;

@protocol giveTimeDelegate <NSObject>

- (void)giveTimeString:(NSString *)giveTimeStr;

@end

@interface RBCustomDatePickerView : UIView <MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate>
@property (nonatomic,copy)NSString *timeStr;

@property (nonatomic, retain) id<giveTimeDelegate>FKdelegate;
@end
