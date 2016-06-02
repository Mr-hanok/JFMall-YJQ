//
//  JFTasKCenterModel.m
//  CommunityApp
//
//  Created by yuntai on 16/5/20.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFTasKCenterModel.h"

/***/
@implementation JFTasKCenterModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.className = [NSMutableDictionary dictionary];
    }
    return self;
}
+(NSMutableArray *)jsonForModelArrayWithDic:(NSDictionary *)dic{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *list =[dic objectForKey:@"missionList"];
    for (NSDictionary *d in list) {
        JFTasKCenterModel *model = [JFTasKCenterModel yy_modelWithDictionary:d];
        
        model.className = [JFTasKCenterModel initClassNameWithModel:model];
        [array addObject:model];
    }
    return  array;
}

+(NSMutableDictionary *)initClassNameWithModel:(JFTasKCenterModel *)m{
    //用户认证
    [m.className setValue:@"RoadAddressManageViewController" forKey:@"key1"];
    //手机绑定
    [m.className setValue:@"PersonalCenterBindTelViewController" forKey:@"key2"];
    //个人信息
    [m.className setValue:@"PersonalCenterModBaseInfoViewController" forKey:@"key3"];
    //物业费
    [m.className setValue:@"PropertyBillWebViewController" forKey:@"key4"];
    //
    [m.className setValue:@"" forKey:@"key5"];
    //摇一摇开门
    [m.className setValue:@"OpenDoorVCNew" forKey:@"key6"];
    //
    [m.className setValue:@"" forKey:@"key7"];
    //新用户登录"
    [m.className setValue:@"PersonalCenterViewController" forKey:@"key8"];
    //问卷调查
    [m.className setValue:@"QuestionSurveyJoinViewController" forKey:@"key9"];
    //物业通知
    [m.className setValue:@"MessageViewController" forKey:@"key10"];
    //物业通知分享
    [m.className setValue:@"MessageViewController" forKey:@"key11"];
    //工程报修
    [m.className setValue:@"CategorySelectedViewController" forKey:@"key12"];
    //工程报修评价
    [m.className setValue:@"" forKey:@"key13"];
    //"意见反馈
    [m.className setValue:@"PersonalCenterSuggestViewController" forKey:@"key14"];
    //商城消费
    [m.className setValue:@"GoodsListViewController" forKey:@"key15"];
    //商品评价
    [m.className setValue:@"GoodsListViewController" forKey:@"key16"];
    return (NSMutableDictionary *)m.className;
}
@end
