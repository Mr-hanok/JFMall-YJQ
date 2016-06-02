//
//  ManJianCollectionCell.m
//  CommunityApp
//
//  Created by yuntai on 16/4/15.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "ManJianCollectionCell.h"
#import <UIImageView+WebCache.h>

@implementation ManJianCollectionCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configCellWith{
    [self.goodsImageIV   sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];
    self.goodsName.text = @"goodsName";
    self.goodsPrice.text = @"1000";
}
@end
