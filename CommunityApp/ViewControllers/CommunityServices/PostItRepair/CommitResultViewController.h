//
//  CommitResultViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

typedef enum EResultViewFromViewID{
    E_ResultViewFromViewID_PostItRepair,
    E_ResultViewFromViewID_SubmitServiceOrder,
    E_ResultViewFromViewID_SubmitCommodityOrder,
    E_ResultViewFromViewID_OrderPayResult,
    E_ResultViewFromViewID_SeverOrderPayResult,//新到家服务
}eCartViewFromViewID;

@interface CommitResultViewController : BaseViewController

@property (nonatomic, assign) eCartViewFromViewID   eFromViewID;

@property (nonatomic, copy) NSString        *resultTitle;   //结果标题
@property (nonatomic, copy) NSString        *resultDesc;    //结果描述
@property (nonatomic, strong) NSString *couponsStr;         //获取到的优惠券，json格式

@end
