//
//  JFOrderInfoCell.m
//  CommunityApp
//
//  Created by yuntai on 16/4/25.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFOrderInfoCell.h"
#import <UIImageView+WebCache.h>

@implementation JFOrderInfoCell

+ (JFOrderInfoCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath{
    
    JFOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JFOrderInfoCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JFOrderInfoCell class]) owner:nil options:0]lastObject];
    }
    
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)configCellWithGoodsInfoModel:(JFGoodsInfoModel *)model{
    
    [self.orderImageIV sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];
    self.orderNameLabel.text = [NSString stringWithFormat:@"%@",model.goods_name];
    self.orderDetailLabel.text = model.spec_info;
    self.orderIntgralLabl.text = [NSString stringWithFormat:@"%@积分",model.goodsIntegral];
    self.orderNumLabel.text = [NSString stringWithFormat:@"X%ld",model.goodsNum];
}

- (void)configCellWithOrderGoodsModel:(JFOrderDetailGoodsModel *)model{
    
    [self.orderImageIV sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];
    self.orderNameLabel.text = [NSString stringWithFormat:@"%@",model.goods_name];
    self.orderDetailLabel.text = model.spec_info;
    self.orderIntgralLabl.text = [NSString stringWithFormat:@"%@积分",model.price];
    self.orderNumLabel.text = [NSString stringWithFormat:@"X%@",model.count];
}
@end
