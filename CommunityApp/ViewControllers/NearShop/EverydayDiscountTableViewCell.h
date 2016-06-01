//
//  EverydayDiscountTableViewCell.h
//  CommunityApp
//
//  Created by iss on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaresDetail.h"
#import "WaresList.h"

@interface EverydayDiscountTableViewCell : UITableViewCell

// 立即抢购 按钮点击处理Block
@property(nonatomic, copy) void(^buyNowBtnClickBlock)(void);

/* 装载Cell数据
 * @parameter:model 商品详细数据模型
 */
- (void)loadCellData:(WaresDetail *)model setBtnTag:(NSInteger)tag;
- (void)loadCellData:(WaresList *)model;


@end
