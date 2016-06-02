//
//  SurroundBusinessTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/7/31.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurroundBusinessModel.h"

@interface SurroundChoiceTableViewCell : UITableViewCell

/* 装载Cell数据
 * @parameter:model 周边商家数据模型
 */
- (void)loadCellData:(SurroundBusinessModel *)model;


@property (nonatomic, copy) void(^dialHotLineBlock)(void);

@end
