//
//  SurroundBusinessTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurroundBusinessModel.h"

@interface SurroundBusinessTableViewCell : UITableViewCell

/**
 * 拨号到商店Block
 */
@property (nonatomic, copy) void (^dialToStoreBlock)(void);


/* 装载Cell数据
 * @parameter:model 周边商家数据模型
 */
- (void)loadCellData:(SurroundBusinessModel *)model;


@end
