//
//  FirstFooterView.m
//  CommunityApp
//
//  Created by issuser on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "FirstFooterView.h"

@implementation FirstFooterView

- (void)awakeFromNib {
    [Common updateLayout:_topLine where:NSLayoutAttributeHeight constant:0.5];
}

@end
