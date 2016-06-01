//
//  ShoppingCartCollectionViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ShoppingCartCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ShoppingCartCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)loadCellData:(RecommendGoods *)goods
{
    NSArray *picUrls = [goods.goodsPic componentsSeparatedByString:@","];
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:[picUrls objectAtIndex:0]]];
    [self.icon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];
    
    [self.name setText:goods.goodsName];
    [self.price setText:[NSString stringWithFormat:@"￥%@", goods.goodsPrice]];
}

@end
