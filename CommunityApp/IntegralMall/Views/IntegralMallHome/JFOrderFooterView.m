//
//  JFOrderFooterView.m
//  CommunityApp
//
//  Created by yuntai on 16/4/25.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFOrderFooterView.h"

@implementation JFOrderFooterView


- (void)configSectionFooterViewWithStoreModel:(JFStoreInfoMode *)store{
    self.orderNumTotalLabel.text = [NSString stringWithFormat:@"共%ld件商品",store.goodsNum];
    NSInteger totalIntegral = 0;
    for (JFGoodsInfoModel *model in store.goodsArray) {
       totalIntegral = totalIntegral + [model.goodsIntegral integerValue]*model.goodsNum;
    }
    
    self.orderIntegralTotalLabel.text = [NSString stringWithFormat:@"总计:%ld积分",totalIntegral];
}
- (void)configSectionFooterViewWithOrderDetaliModel:(JFOrderDetailModel *)model{
    self.orderNumTotalLabel.text = [NSString stringWithFormat:@"共%@件商品",model.total_count];
    self.orderIntegralTotalLabel.text = [NSString stringWithFormat:@"总计:%@积分",model.total_price];
}
@end
