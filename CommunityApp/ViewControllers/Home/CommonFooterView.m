//
//  CommonFooterView.m
//  CommunityApp
//
//  Created by issuser on 15/7/1.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CommonFooterView.h"

@implementation CommonFooterView

- (void)awakeFromNib {
    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];
}

@end
