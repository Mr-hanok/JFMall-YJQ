//
//  GYZChooseCityController.h
//  GYZChooseCityDemo
//
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GYZCity.h"
#import "GYZChooseCityDelegate.h"

#define xuanzebong1 IP456ELSE(9, 9,11)//Constants.h中添加
#define     MAX_COMMON_CITY_NUMBER      8
#define     COMMON_CITY_DATA_KEY        @"GYZCommonCityArray"
//#define IOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8.0

//@protocol GYZChooseCityDelegate <NSObject>
//@optional
//- (void)setSelectedNeighborhoodId:(NSString *)projectId andName:(NSString*)projectName andqrCode:(NSString *)qrCode;
//@end

@interface GYZChooseCityController : BaseViewController
@property (nonatomic, copy) void(^selectNeighborhoodBlock)(GYZCity*);
@property (nonatomic, assign) id <GYZChooseCityDelegate> delegate;
@property (nonatomic, assign) BOOL  isRootVC;
@property (nonatomic, assign) BOOL  isSaveData;
/*
 *  定位城市id
 */
@property (nonatomic, strong) NSString *locationCityID;
/*
 *  常用城市id数组,自动管理，也可赋值
 */
@property (nonatomic, strong) NSMutableArray *commonCitys;
/*
 *  城市数据，可在Getter方法中重新指定
 */
@property (nonatomic, strong) NSMutableArray *cityDatas;

@end
