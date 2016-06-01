//
//  ShoppingCartFooterView.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ShoppingCartFooterView.h"

@implementation ShoppingCartFooterView

- (void)awakeFromNib {
    [Common updateLayout:_topLine where:NSLayoutAttributeHeight constant:0.5];
}

@end
