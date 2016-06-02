//
//  OpenDoorViewController.h
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#define Str_One         @"1"
#define Str_Two         @"2"
#define Str_Three       @"3"
#define Str_Fore        @"4"

@interface OpenDoorViewController : BaseViewController
@property(nonatomic,copy)NSString *resultStr;
@property(nonatomic,copy)NSString *resultReason;
@property(nonatomic,assign)int UseTime;
@property(nonatomic,copy)NSString *key;
//地址数据
@property (retain, nonatomic) NSMutableArray *roadDataArray;
@property(nonatomic,strong)NSArray*authenStatusarray;
@end
