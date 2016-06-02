//
//  HeaderCollectionReusableView.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "HeaderCollectionReusableView.h"


@interface HeaderCollectionReusableView()

@property(nonatomic, strong) NSArray *colorArray;

@end

@implementation HeaderCollectionReusableView

- (void)awakeFromNib {
    [self initDatas];
    [Common updateLayout:_topLine where:NSLayoutAttributeHeight constant:0.5];
}

- (void)initDatas {
    _colorArray = @[UIColorFromRGB(0xea9d31), UIColorFromRGB(0x39b1a7), UIColorFromRGB(0x4cadda), UIColorFromRGB(0xe06843)];
}

- (IBAction)headerClickHandler:(id)sender {
    if (self.headerClickBlock) {
        self.headerClickBlock();
    }
}

- (void)setTitle:(NSString *)title atIndex:(NSInteger)index
{
    UIColor *color = _colorArray[index % _colorArray.count];
    
    self.categoryName.text = title;
    self.categoryName.textColor = color;
    self.tipLine.backgroundColor = color;
}

@end
