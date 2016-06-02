//
//  JFShoppingCarCell.h
//  CommunityApp
//
//  Created by yuntai on 16/4/20.
//  Copyright © 2016年 iss. All rights reserved.
//
@class JFShoppingCarCell;
@class JFGoodsInfoModel;
@protocol JFShoppingCarCellDelegate <NSObject>

- (void)shoppingCarCell:(JFShoppingCarCell *)cell andFlag:(int)flag;
- (void)shoppingCarCell:(JFShoppingCarCell *)cell andDelBtn:(UIButton *)delBtn;
- (void)shoppingCarCell:(JFShoppingCarCell *)cell andSelectBtn:(UIButton *)selBtn model:(JFGoodsInfoModel *)model;

@end
#import <UIKit/UIKit.h>
#import "JFGoodsInfoModel.h"
/**
 *  购物车cell
 */
@interface JFShoppingCarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsIV;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsIntegralLabel;
@property (weak, nonatomic) IBOutlet UIButton *goodsDelBtn;
@property (weak, nonatomic) IBOutlet UITextField *goodsNumTF;
@property (weak, nonatomic) IBOutlet UIButton *goodsAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodsSelectBtn;

@property (nonatomic, strong) JFGoodsInfoModel *model;

@property (nonatomic,weak)id<JFShoppingCarCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;

+ (JFShoppingCarCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath  delegate:(id)object;
//赋值
-(void)instalTheValue:(JFGoodsInfoModel *)goodsModel;

@end
