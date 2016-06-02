//
//  GoodsForSaleTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GoodsForSaleTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface GoodsForSaleTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *bgCellView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsAmountLabel;
@end

@implementation GoodsForSaleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initTableCellStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initTableCellStyle {
    CALayer *layer =  _bgCellView.layer;
    layer.borderColor = Color_Coupon_Border.CGColor;
    layer.cornerRadius = 5;
    layer.borderWidth = 1;
    layer.masksToBounds = YES;
}

- (void)loadCellData:(WaresList *)model {
    NSURL *url = [NSURL URLWithString:[Common setCorrectURL:model.goodsUrl]];
    [_goodsImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    [_goodsNameLabel setText:model.goodsName];
    [_goodsAmountLabel setText:model.goodsPrice];
}

@end
