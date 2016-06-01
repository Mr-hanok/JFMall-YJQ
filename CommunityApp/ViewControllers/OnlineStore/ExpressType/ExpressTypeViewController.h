//
//  ExpressTypeViewController.h
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "ExpressTypeModel.h"

@protocol ExpressTypeViewDelegate <NSObject>

@optional
- (void)setSelectedExpressType:(ExpressTypeModel *)model;

@end


@interface ExpressTypeViewController : BaseViewController

@property (nonatomic, assign) id<ExpressTypeViewDelegate>  delegate;

@property (nonatomic, retain) NSArray   *expressList;

@property (nonatomic, copy) void(^selectExpressTypeBlock)(ExpressTypeModel *typeName);

@end
