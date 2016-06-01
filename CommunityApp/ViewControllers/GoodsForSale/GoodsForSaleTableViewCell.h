//
//  GoodsForSaleTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendGoods.h"

@interface GoodsForSaleTableViewCell : UITableViewCell
- (void)loadCellData:(RecommendGoods *)model;
@end
