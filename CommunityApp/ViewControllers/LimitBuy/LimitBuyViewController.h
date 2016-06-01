//
//  LimitBuyViewController.h
//  CommunityApp
//
//  Created by issuser on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodsCategoryModel.h"


@interface LimitBuyViewController : BaseViewController

@property (nonatomic, retain) GoodsCategoryModel *goodsCategory;

@property (nonatomic, copy) NSString    *searchContent;

@end
