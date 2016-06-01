//
//  JFBannerModel.h
//  CommunityApp
//
//  Created by yuntai on 16/5/10.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  轮播图模型
 */
@interface JFBannerModel : NSObject
@property (nonatomic, copy) NSString *kid;
@property (nonatomic, copy) NSString *ordre_num;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *pub_type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pic_path;
@property (nonatomic, copy) NSString *whereuse;
@property (nonatomic, copy) NSString *jump_url;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *deleteStatus;

+ (JFBannerModel *)initModelWith:(NSDictionary *)dic;
@end
