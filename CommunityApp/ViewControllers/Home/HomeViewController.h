//
//  HomeViewController.h
//  CommunityApp
//
//  Created by issuser on 15/6/2.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#define Str_One         @"1"
#define Str_Two         @"2"
#define Str_Three       @"3"
#define Str_Fore        @"4"
#define Str_Five        @"5"   //2016.02.22


@interface HomeViewController : BaseViewController

@property (nonatomic, copy) NSString    *projectId;     //项目(小区）ID
@property (nonatomic, copy) NSString    *projectName;   //项目(小区）名
//🍎
@property (nonatomic,copy) NSString     *qrCode;
//开门
@property(nonatomic,copy)NSString *resultStr;
@property(nonatomic,copy)NSString *resultReason;
@property(nonatomic,assign)int UseTime;
@property(nonatomic,copy)NSString *key;

@property (nonatomic,strong) UIScrollView *mScrollView;

//地址数据
@property (retain, nonatomic) NSMutableArray *roadDataArray;
@property(nonatomic,strong)NSArray*authenStatusarray;

@end
