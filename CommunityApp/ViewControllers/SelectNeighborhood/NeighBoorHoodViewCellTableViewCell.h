//
//  NeighBoorHoodViewCellTableViewCell.h
//  CommunityApp
//
//  Created by iss on 15/6/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import "NeighBorHoodModel.h"

@interface NeighBoorHoodViewCellTableViewCell : UITableViewCell


/* 装载Cell数据
 * @parameter:model 小区数据模型
 */
- (void)loadCellData:(NeighBorHoodModel *)model;

@end
