//
//  ShoppingCartServiceTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/12.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartModel.h"

@interface ShoppingCartServiceTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^checkBoxStatusChangeBlock)(BOOL);

/**
 * 设置CheckBox选中状态
 */
- (void)setCheckBoxSelected;

/**
 * 指定CheckBox选择状态
 */
- (void)setCheckBoxSelectStatus:(BOOL)status;


/**
 * 装载Cell数据
 * model: 购物车数据模型
 */
- (void)loadCellData:(ShopCartModel *)model;


@end
