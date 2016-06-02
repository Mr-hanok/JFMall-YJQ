//
//  SelectNeighborhoodViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//  选择小区

#import "BaseViewController.h"
#import "NeighBoorHoodViewCellTableViewCell.h"
#import "NeighBorHoodModel.h"


@protocol SelectNeighborhoodDelegate <NSObject>

@optional
//- (void)setSelectedNeighborhoodId:(NSString *)projectId andName:(NSString*)projectName;
- (void)setSelectedNeighborhoodId:(NSString *)projectId andName:(NSString*)projectName andqrCode:(NSString *)qrCode;


@end

@interface SelectNeighborhoodViewController : BaseViewController

@property (nonatomic, copy) void(^selectNeighborhoodBlock)(NeighBorHoodModel*);

@property (nonatomic, assign) id<SelectNeighborhoodDelegate> delegate;

@property (nonatomic, assign) BOOL  isRootVC;
@property (nonatomic, assign) BOOL  isSaveData;
@end
