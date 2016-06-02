//
//  NeighBorHoodModel.h
//  CommunityApp
//
//  Created by issuser on 15/6/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"
//小区数据模型
@interface NeighBorHoodModel : BaseModel

@property (nonatomic, copy) NSString    *projectId;     // 小区ID
@property (nonatomic, copy) NSString    *projectName;   // 小区名称
@property (nonatomic, copy) NSString     *qrCode;       //二维码
/*
 *  城市名称-拼音首字母
 */
@property (nonatomic, strong) NSString *initials;
//最近城市模型
@property (nonatomic, copy) NSString    *distance;     //最近距离

@end
//#pragma mark - GYZCityGroup
//@interface GYZCityGroup : NSObject
//
///*
// *  分组标题
// */
//@property (nonatomic, strong) NSString *cityNames;
//
///*
// *  小区数组
// */
//@property (nonatomic, strong) NSMutableArray *arrayProjects;

//@end
