//
//  JFHomeGoodsCell.m
//  CommunityApp
//
//  Created by yuntai on 16/4/19.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFHomeGoodsCell.h"
#import <UIImageView+WebCache.h>

@implementation JFHomeGoodsCell

//+ (JFHomeGoodsCell  *)collectview:(UICollectionView *)collectview cellForRowInCollectviewIndexPath:(NSIndexPath *)indexPath{
//    
//    JFHomeGoodsCell *cell = [collectview dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JFHomeGoodsCell class]) forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JFHomeGoodsCell class]) owner:self options:0]lastObject];
//    }
//    
//    cell.indexPath = indexPath;
//    return cell;
//}

- (void)awakeFromNib {
    // Initialization code
}
- (void)configGoodsCellWithGoodsModel:(JFHomeGoodsModel *)model{
    [self.goodsImageIV sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];
    self.goodsNameLabel.text = [NSString stringWithFormat:@"%@%@",@"",model.goods_name];
    self.goodsIntegralLabel.text = [NSString stringWithFormat:@"%@积分",model.goods_price];
    self.goodPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.store_price];
}
@end
