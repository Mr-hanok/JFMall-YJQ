//
//  JFHomeGoodsCell.h
//  CommunityApp
//
//  Created by yuntai on 16/4/19.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFGoodsInfoModel.h"
#import "JFCategorysModel.h"
/**
 *  积分首页 商品cell
 */
@interface JFHomeGoodsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageIV;//图片
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;//名称 标签
@property (weak, nonatomic) IBOutlet UILabel *goodsIntegralLabel;//积分
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;//价格

@property (strong, nonatomic) NSIndexPath *indexPath;

//+ (JFHomeGoodsCell  *)collectview:(UICollectionView *)collectview cellForRowInCollectviewIndexPath:(NSIndexPath *)indexPath;
- (void)configGoodsCellWithGoodsModel:(JFHomeGoodsModel *)model;
@end
