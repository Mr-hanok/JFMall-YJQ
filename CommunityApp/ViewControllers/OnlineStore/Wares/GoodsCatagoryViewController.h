//
//  GoodsCatagoryViewController.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodsCategoryModel.h"

typedef enum E_GoodsCategory_Module{
    E_GoodsCategoryModule_Normal,       // 普通精品优选
    E_GoodsCategoryModule_FleaMarket,   // 跳蚤市场
    E_GoodsCategoryModule_Other,        // 其他
}EGoodsCategoryModule;


@interface GoodsCatagoryViewController : BaseViewController


@property (nonatomic, copy) void(^selectGoodsCategoryBlock)(GoodsCategoryModel *model);

@property (nonatomic, assign) EGoodsCategoryModule  eGoodsCategoryModule;

@end
