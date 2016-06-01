//
//  NormalGoodsListViewController.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodsCategoryModel.h"

typedef enum E_SearchGoods_Type{
    E_SearchGoodsType_All,          // 搜索全部商品
    E_SearchGoodsType_Category,     // 搜索指定类别商品
    E_SearchGoodsType_Other,        // 其他
}ESearchGoodsType;


@interface NormalGoodsListViewController : BaseViewController

@property (nonatomic, retain) GoodsCategoryModel    *goodsCategory;
@property (nonatomic, copy)   NSString              *searchContent;
@property (nonatomic, assign) ESearchGoodsType      eSearchGoodsType;

@end
