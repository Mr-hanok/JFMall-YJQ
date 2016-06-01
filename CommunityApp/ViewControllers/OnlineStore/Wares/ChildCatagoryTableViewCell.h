//
//  ChildCatagoryTableViewCell.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCategoryModel.h"

@interface ChildCatagoryTableViewCell : UITableViewCell


/* 装载Cell数据
 * @parameter:model 商品分类数据模型
 */
- (void)loadCellData:(GoodsCategoryModel *)model;

@end
