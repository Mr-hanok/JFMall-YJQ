//
//  CSPRPostRepairEditViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//  报事内容编辑

#import "BaseViewController.h"
#import "NewNormalAddressViewController.h"
@interface PostRepairEditViewController : BaseViewController
@property (copy,nonatomic) NSString* serviceId;

@property (copy,nonatomic) NSString* projectId;
@property (copy,nonatomic) NSString* buildingId;

@property(copy,nonatomic)NSString*projectName;
@property(copy,nonatomic)NSString*progectAddress;

@end
