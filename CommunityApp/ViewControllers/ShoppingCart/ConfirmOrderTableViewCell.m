//
//  ConfirmOrderTableViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ConfirmOrderTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ConfirmOrderTableViewCell

- (void)awakeFromNib {
    [Common updateLayout:_hLine where:NSLayoutAttributeHeight constant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 加载Cell数据
- (void)loadCellData:(ShopCartModel *)model
{
    NSArray *picUrls = [model.picUrl componentsSeparatedByString:@","];
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:[picUrls objectAtIndex:0]]];
    [self.goodsImg setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];
    
    [self.goodsName setText:model.wsName];
    if ([model isUseSpecialOfferRight]) {
        [self.goodsPrice setNewPrice:model.specialOfferPrice oldPrice:model.currentPrice];
    }
    else {
        [self.goodsPrice setText:[NSString stringWithFormat:@"¥%@",model.currentPrice]];
    }
    
    NSString *count = [NSString stringWithFormat:@"x%ld", model.count];
    [self.goodsCount setText:count];
    
    // 插入标签
    NSArray *waresStyles = [model.waresStyle componentsSeparatedByString:@","];
    [Common insertLabelForStrings:waresStyles toView:self.labelView andViewHeight:27.0 andMaxWidth:(Screen_Width-154) andLabelHeight:18.0 andLabelMargin:5 andAddtionalWidth:2 andFont:[UIFont systemFontOfSize:12.0] andBorderColor:Color_Comm_LabelBorder andTextColor:COLOR_RGB(120, 120, 120)];
}


@end
