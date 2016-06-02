//
//  JFPrizeModel.h
//  CommunityApp
//
//  Created by yuntai on 16/6/2.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
/**奖品信息Model*/

@interface JFPrizeModel : NSObject

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *prize_name;
@property (nonatomic, copy) NSString *prize_type;
@property (nonatomic, copy) NSString *goods_pic;
@property (nonatomic, copy) NSString *award_status;
@end
