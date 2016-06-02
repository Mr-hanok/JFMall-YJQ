//
//  SurroundBusinessReviewModel.h
//  CommunityApp
//
//  Created by iss on 7/13/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseModel.h"

@interface SurroundBusinessReviewModel : BaseModel
@property(nonatomic, copy) NSString     *reviewId;     //评论ID
@property(nonatomic, copy) NSString     *submitName;   //提交人
@property(nonatomic, copy) NSString     *submitUserId; //提交人id
@property(nonatomic, copy) NSString     *submitDate;   //提交时间
@property(nonatomic, copy) NSString     *score;        //评分
@property(nonatomic, copy) NSString     *perConsumption;//人均消费
@property(nonatomic, copy) NSString     *desc;          //评价
@property(nonatomic, copy) NSString     *submitUserAccount;// 提交人账户
@property(nonatomic, copy) NSString     *filePath;      // 用户头像
@end
