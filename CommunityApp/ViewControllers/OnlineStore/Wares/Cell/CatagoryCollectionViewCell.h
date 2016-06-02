//
//  CatagoryCollectionViewCell.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCategoryModel.h"
#import "WaresList.h"

@interface CatagoryCollectionViewCell : UICollectionViewCell


// 加载Cell数据
- (void)loadCellData:(GoodWaresList *)model;

@end
