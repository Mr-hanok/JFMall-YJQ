//
//  ShoppingCartHeaderView.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ShoppingCartHeaderView.h"
#import "GoodsForSaleViewController.h"

@implementation ShoppingCartHeaderView

- (void)awakeFromNib {
    [Common updateLayout:_topLine where:NSLayoutAttributeHeight constant:0.5];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(storeBtnClickHandler:)];
    [_shopName addGestureRecognizer:tap];
}

- (IBAction)sectionCheckBtnClickHandler:(id)sender {
    if (self.sectionCheckBoxClickBlock) {
        self.sectionCheckBoxClickBlock(self);
    }
}
- (IBAction)storeBtnClickHandler:(id)sender
{
    if (self.storeBtnBlock) {
        self.storeBtnBlock(self);
    }
}
@end
