//
//  FilterViewController.h
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

@protocol FilterViewDelegate <NSObject>

@optional
- (void)setFileterData:(NSString *)filters;

@end

@interface FilterViewController : BaseViewController

@property (nonatomic, assign) id<FilterViewDelegate>  delegate;

@end
