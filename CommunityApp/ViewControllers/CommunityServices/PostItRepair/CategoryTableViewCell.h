//
//  CSPRcategoryTableViewCell.h
//  CommunityApp
//
//  Created by iss on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostItRepairCategoryModel.h"

@interface CategoryTableViewCell : UITableViewCell


/* 装载Cell数据
 * @parameter:model 工程报修分类数据模型
 */
- (void)loadCellData:(PostItRepairCategoryModel *)model;

@end
