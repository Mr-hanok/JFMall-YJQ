//
//  BenefitPeopleCollectionViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BenefitPeopleCollectionViewCell.h"
#import "UIButton+AFNetworking.h"

@interface BenefitPeopleCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *benefitView;
@property (weak, nonatomic) IBOutlet UIView *groupBuyView;
@property (weak, nonatomic) IBOutlet UIView *fleaMarketView;
@property (weak, nonatomic) IBOutlet UIView *limitBuyView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *benefitViewWidth;

@property (weak, nonatomic) IBOutlet UIImageView *vLine1;
@property (weak, nonatomic) IBOutlet UIImageView *hLine1;
@property (weak, nonatomic) IBOutlet UIImageView *vLine2;

@end

@implementation BenefitPeopleCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    // 惠民专区
//    {
//        _benefitView.layer.borderColor = COLOR_RGB(220, 220, 220).CGColor;
//        _benefitView.layer.borderWidth = 0.5;
//
//    }
//    
//    // 团购
//    _groupBuyView.layer.borderColor = COLOR_RGB(220, 220, 220).CGColor;
//    _groupBuyView.layer.borderWidth = 0.5;
//    
//    // 二手市场
//    _fleaMarketView.layer.borderColor = COLOR_RGB(220, 220, 220).CGColor;
//    _fleaMarketView.layer.borderWidth = 0.5;
//    
//    // 限时抢
//    _limitBuyView.layer.borderColor = COLOR_RGB(220, 220, 220).CGColor;
//    _limitBuyView.layer.borderWidth = 0.5;
    
    [Common updateLayout:_vLine1 where:NSLayoutAttributeWidth constant:0.5];
    [Common updateLayout:_vLine2 where:NSLayoutAttributeWidth constant:0.5];
    [Common updateLayout:_hLine1 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_topLine where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];
}


// 惠民专区按钮点击处理函数
- (IBAction)selectFunctionAreaHandler:(UIButton *)sender
{
    if (self.selectFunctionAreaBlock) {
        self.selectFunctionAreaBlock(sender.tag);
    }
}

// 加载CellInfo
- (void)loadCellDataForGroupon:(AdImgSlideInfo *)groupon andLimitBuy:(AdImgSlideInfo *)limitBuy
{
//    if (groupon && groupon.picPath && groupon.picPath.length>0) {
//        NSURL *bgUrl = [NSURL URLWithString:[Common setCorrectURL:groupon.picPath]];
//        [_grouponBtn setBackgroundImageForState:UIControlStateNormal withURL:bgUrl placeholderImage:[UIImage imageNamed:@"GroupBuyImgNor"]];
//        [_grouponBtn setBackgroundImageForState:UIControlStateHighlighted withURL:bgUrl placeholderImage:[UIImage imageNamed:@"GroupBuyImgPre"]];
//    }
    if (limitBuy && limitBuy.picPath && limitBuy.picPath.length>0) {
        NSURL *bgUrl = [NSURL URLWithString:[Common setCorrectURL:limitBuy.picPath]];
        [_limitBuyBtn setBackgroundImageForState:UIControlStateNormal withURL:bgUrl placeholderImage:[UIImage imageNamed:@"LimitBuyBgNor"]];
        [_limitBuyBtn setBackgroundImageForState:UIControlStateHighlighted withURL:bgUrl placeholderImage:[UIImage imageNamed:@"LimitBuyBgPre"]];
    }
}


@end
