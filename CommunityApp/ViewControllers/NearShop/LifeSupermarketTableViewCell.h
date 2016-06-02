//
//  LifeSupermarketTableViewCell.h
//  CommunityApp
//
//  Created by iss on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurroundBusinessModel.h"
@class LifeSupermarketTableViewCell;

// 声明代理
@protocol marketCellDelegate <NSObject>
    - (void)marketCell:(LifeSupermarketTableViewCell *)cell;
@end

@interface LifeSupermarketTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *callMe;
@property (retain, nonatomic) id<marketCellDelegate> delegate;

/* 装载Cell数据
 * @parameter:model 周边商家数据模型
 */
- (void)loadCellData:(SurroundBusinessModel *)model;

- (IBAction)clickCallMe:(id)sender;

@end
