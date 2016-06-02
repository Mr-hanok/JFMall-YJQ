//
//  CouponShareAddressCell.m
//  CommunityApp
//
//  Created by Andrew on 15/9/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CouponShareAddressCell.h"
#import "GrouponShop.h"
#import <Masonry/Masonry.h>

@interface CouponShareAddressCell ()

@property (nonatomic, strong) UIImageView *checkBoxImageView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *shopAddressLabel;
@property (nonatomic, strong) UILabel *shopPhoneLabel;

@end

@implementation CouponShareAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.checkBoxImageView];
        [self.contentView addSubview:self.shopNameLabel];
        [self.contentView addSubview:self.shopAddressLabel];
        [self.contentView addSubview:self.shopPhoneLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self.checkBoxImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(16);
        make.top.equalTo(self.contentView.mas_top).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkBoxImageView.mas_centerY);
        make.left.equalTo(self.checkBoxImageView.mas_right).with.offset(8);
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.height.equalTo(@20);
    }];
    [self.shopAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopNameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.top.equalTo(self.shopNameLabel.mas_bottom).with.offset(8);
        make.height.equalTo(@20);
    }];
    [self.shopPhoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopAddressLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.top.equalTo(self.shopAddressLabel.mas_bottom).with.offset(8);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.checkBoxImageView.image = [UIImage imageNamed:@"CheckBoxOK"];
    }
    else {
        self.checkBoxImageView.image = [UIImage imageNamed:@"CheckBoxNo"];
    }
}

-(void)setShopInfo:(GrouponShop *)shopInfo
{
    self.shopNameLabel.text = shopInfo.shopName;
    self.shopAddressLabel.text = shopInfo.address;
    self.shopPhoneLabel.text = shopInfo.shopTelNo;
}

- (UIImageView *)checkBoxImageView
{
    if (!_checkBoxImageView) {
        _checkBoxImageView = [[UIImageView alloc] init];
    }
    return _checkBoxImageView;
}

- (UILabel *)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.font = [UIFont systemFontOfSize:16];
        _shopNameLabel.textColor = [UIColor colorWithWhite:0.369 alpha:1.000];
    }
    return _shopNameLabel;
}

- (UILabel *)shopAddressLabel
{
    if (!_shopAddressLabel) {
        _shopAddressLabel = [[UILabel alloc] init];
        _shopAddressLabel.font = [UIFont systemFontOfSize:14];
        _shopAddressLabel.textColor = [UIColor colorWithWhite:0.369 alpha:1.000];
    }
    return _shopAddressLabel;
}

- (UILabel *)shopPhoneLabel
{
    if (!_shopPhoneLabel) {
        _shopPhoneLabel = [[UILabel alloc] init];
        _shopPhoneLabel.font = [UIFont systemFontOfSize:14];
        _shopPhoneLabel.textColor = [UIColor colorWithWhite:0.369 alpha:1.000];
    }
    return _shopPhoneLabel;
}

@end
