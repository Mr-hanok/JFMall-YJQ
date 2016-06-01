//
//  ShoppingCartTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/12.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartCountButton.h"
#import "ShopCartModel.h"

typedef void(^CountChangeBlock)(NSInteger);

@interface ShoppingCartTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (nonatomic, retain) CartCountButton *countBtn;

@property (nonatomic, copy) void(^checkBoxStatusChangeBlock)(BOOL);

@property (retain, nonatomic) IBOutlet UIButton *checkBox;

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

- (void)resetShowPrice:(ShopCartModel *)model;

@end
