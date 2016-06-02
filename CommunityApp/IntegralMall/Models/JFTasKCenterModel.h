//
//  JFTasKCenterModel.h
//  CommunityApp
//
//  Created by yuntai on 16/5/20.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
/**任务中心模型*/
@interface JFTasKCenterModel : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *missionName;
@property (nonatomic, copy) NSString *totalIntegral;
@property (nonatomic, copy) NSString *integral;
/**0->一次性任务未完成 1->不是一次性任务 2->一次性任务完成*/
@property (nonatomic, copy) NSString *isFinish;

@property (nonatomic, strong) NSMutableDictionary *className;

+(NSMutableArray *)jsonForModelArrayWithDic:(NSDictionary *)dic;
+(NSMutableDictionary *)initClassNameWithModel:(JFTasKCenterModel *)m;
@end
