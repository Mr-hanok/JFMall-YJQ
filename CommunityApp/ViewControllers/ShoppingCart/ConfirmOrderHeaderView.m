//
//  ConfirmOrderHeaderView.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ConfirmOrderHeaderView.h"

@implementation ConfirmOrderHeaderView

- (void)awakeFromNib {
    [Common updateLayout:_hLine where:NSLayoutAttributeHeight constant:0.5];
}

@end
