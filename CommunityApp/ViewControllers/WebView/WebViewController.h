//
//  WebViewController.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/19.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController

@property (nonatomic, copy) NSString    *url;
@property (nonatomic, copy) NSString    *filePath;
@property (nonatomic, copy) NSString    *navTitle;
//11-30新服务订单传的数据
@property (nonatomic,strong) NSString *morderId;
@property (nonatomic,strong) NSString *morderNo;
@property (nonatomic,strong) NSString *memoney;
#pragma -mark 11-30js 交互的几个方法
- (void)clickOnAndroidForOrderInfo:(NSString *)orderId andorderNo:(NSString *)orderNo andMoney:(NSString *)money;

- (NSString *)clickOnAndroidForOrderNo;

- (NSString *)clickOnAndroidForMoney;
//11-30
@end
