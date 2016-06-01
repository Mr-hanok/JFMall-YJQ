//
//  GYZCity.h
//  GYZChooseCityDemo
//
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYZCity : NSObject
/*
 *  城市ID
 */
@property (nonatomic, strong) NSString *projectId;

/*
 *  城市名称
 */
@property (nonatomic, strong) NSString *projectName;
/*
 *  二维码
 */
@property (nonatomic, strong) NSString *qrCode;
/*
 *  短名称
 */
@property (nonatomic, strong) NSString *shortName;

/*
 *  城市名称-拼音
 */
@property (nonatomic, strong) NSString *pinyin;

/*
 *  城市名称-拼音首字母
 */
@property (nonatomic, strong) NSString *initials;
/*
 *  距离
 */
@property (nonatomic, strong) NSString *distance;
@end

#pragma mark - GYZCityGroup
@interface GYZCityGroup : NSObject
/*
 *  分组标题
 */
@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, strong) NSString *firstName;
/*
 *  城市数组
 */
@property (nonatomic, strong) NSMutableArray *arrayCitys;

@end
