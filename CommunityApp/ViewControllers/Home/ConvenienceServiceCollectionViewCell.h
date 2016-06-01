//
//  ConvenienceServiceCollectionViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceList.h"

@interface ConvenienceServiceCollectionViewCell : UICollectionViewCell

/* 装载Cell数据
 * @parameter:model 服务列表数据
 */
- (void)loadCellData:(ServiceList *)model;

/* 装载Cell数据For更多
 */
- (void)loadCellDataForMore;

@end
