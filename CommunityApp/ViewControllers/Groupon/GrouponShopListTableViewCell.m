//
//  GrouponShopListTableViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/25.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponShopListTableViewCell.h"

@implementation GrouponShopListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadCellData:(GrouponShop *)shop
{
    [_shopName setText:shop.shopName];
    [_shopTelno setText:shop.shopTelNo];
    [_shopAddress setText:shop.address];
}


#pragma mark - 拨号按钮点击事件处理函数
- (IBAction)dialBtnClickHandler:(id)sender
{
    if (self.dialToShopBlock) {
        self.dialToShopBlock(_shopTelno.text);
    }
}

@end
