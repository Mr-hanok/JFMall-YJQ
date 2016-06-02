//
//  JFShoppingCarCell.m
//  CommunityApp
//
//  Created by yuntai on 16/4/20.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFShoppingCarCell.h"
#import <UIImageView+WebCache.h>

@implementation JFShoppingCarCell
+ (JFShoppingCarCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath  delegate:(id)object{
    
    JFShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JFShoppingCarCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JFShoppingCarCell class]) owner:nil options:0]lastObject];
    }
    
    cell.delegate = object;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

    
}
- (void)awakeFromNib {
    
    self.goodsDelBtn.layer.cornerRadius = 3.f;
    self.goodsDelBtn.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)instalTheValue:(JFGoodsInfoModel *)goodsModel{
    self.model = goodsModel;
    self.goodsSelectBtn.selected = goodsModel.isSelect;

    if (goodsModel.isEdite) {
        self.goodsDelBtn.hidden = NO;
    }else{
        self.goodsDelBtn.hidden = YES;
    }
    self.goodsNumTF.text = [NSString stringWithFormat:@"%d",goodsModel.goodsNum];
    [self.goodsIV sd_setImageWithURL:[NSURL URLWithString:goodsModel.goods_img]  placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];
    self.goodsNameLabel.text = goodsModel.goods_name;
    self.goodsIntegralLabel.text = [NSString stringWithFormat:@"%@积分",goodsModel.goodsIntegral];
    self.goodsDetailLabel.text = goodsModel.spec_info;
    
    
}
- (IBAction)addMinusBtnClick:(UIButton *)sender {
    if (sender.tag == 101) {
        //减数量
    }
    if (sender.tag == 102) {
        //加数量
    }
    if ([self.delegate respondsToSelector:@selector(shoppingCarCell:andFlag:)]) {
        [self.delegate shoppingCarCell:self andFlag:(int)sender.tag];
    }
}
- (IBAction)goodsSelecBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([_delegate respondsToSelector:@selector(shoppingCarCell:andSelectBtn:model:)]) {
        [_delegate shoppingCarCell:self andSelectBtn:self.goodsSelectBtn model:self.model];
    }
}
- (IBAction)goodsDeleteBtnClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(shoppingCarCell:andDelBtn:)]) {
        [_delegate shoppingCarCell:self andDelBtn:self.goodsDelBtn];
    }
}

@end
