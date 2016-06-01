//
//  GoodsCollectionViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GoodsCollectionViewCell.h"
#import "UIButton+AFNetworking.h"
#import "UILabel+Price.h"
@implementation GoodsCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - 加载Cell数据
- (void)loadCellData:(WaresList *)wares
{
    NSArray *goodsUrl = [wares.goodsUrl componentsSeparatedByString:@","];
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:[goodsUrl objectAtIndex:0]]];
    [_goodsImgBtn setBackgroundImageForState:UIControlStateNormal withURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    
    [_goodsName setText:wares.goodsName];
#pragma -mark  12-16当是首件特价商品时显示原价

    if ([wares isSpecialOfferGoods]) {
        [_goodsPrice setNewPrice:wares.specialOfferPrice oldPrice:wares.goodsPrice];
    }
    else
    {

        [_goodsPrice setText:[NSString stringWithFormat:@"¥%@", wares.goodsPrice]];//普通商品显示现价
    }

}


#pragma mark - 商品图片点击事件处理函数
- (IBAction)goodsImgBtnClickHandler:(id)sender
{
    if (self.goodsImgBtnClickBlock)
    {
        self.goodsImgBtnClickBlock();
    }
}

#pragma mark - 购物车按钮点击事件处理函数
- (IBAction)cartBtnClickHandler:(id)sender
{
    if (self.cartBtnClickBlock) {
        self.cartBtnClickBlock();
    }
}


@end
