//
//  CouponShareCouponCell.m
//  CommunityApp
//
//  Created by Andrew on 15/9/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CouponShareCouponCell.h"
#import <Masonry/Masonry.h>
#import "GrouponTicket.h"

@interface CouponShareCouponCell ()

@property (nonatomic, strong) UIImageView *checkBoxImageView;
@property (nonatomic, strong) UILabel *couponNameLabel;
@property (nonatomic, strong) UILabel *couponNumberLabel;
@property (nonatomic, strong) UILabel *couponStateLabel;

@end

@implementation CouponShareCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.checkBoxImageView];
        [self.contentView addSubview:self.couponNameLabel];
        [self.contentView addSubview:self.couponNumberLabel];
        [self.contentView addSubview:self.couponStateLabel];
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
        make.left.equalTo(self.contentView.mas_left).with.offset(8);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [self.couponNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkBoxImageView.mas_right).with.offset(8);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@50);
        make.width.equalTo(@60);
    }];
    [self.couponStateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@50);
        make.width.equalTo(@60);
    }];
    [self.couponNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.couponNameLabel.mas_right).with.offset(8);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.couponStateLabel.mas_left).with.offset(-8);;
        make.height.equalTo(@50);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.checkBoxImageView.image = [UIImage imageNamed:@"CheckBoxOK"];
    }
    else {
        self.checkBoxImageView.image = [UIImage imageNamed:@"CheckBoxNorImg"];
    }
}

- (void)setTicket:(ticketModel *)ticket
{
    _ticket = ticket;
    self.couponNumberLabel.text = ticket.ticketNo;
    self.couponStateLabel.text = [ticket.ticketStatus isEqualToString:@"0"] ? @"未使用" : @"已使用";
}

- (void)setTicketIndex:(NSInteger)ticketIndex
{
    _ticketIndex = ticketIndex;
    self.couponNameLabel.text = [NSString stringWithFormat:@"团购券%li", (unsigned long)ticketIndex];
}

- (UIImageView *)checkBoxImageView
{
    if (!_checkBoxImageView) {
        _checkBoxImageView = [[UIImageView alloc] init];
    }
    return _checkBoxImageView;
}

- (UILabel *)couponNameLabel
{
    if (!_couponNameLabel) {
        _couponNameLabel = [[UILabel alloc] init];
        _couponNameLabel.font = [UIFont systemFontOfSize:14];
        _couponNameLabel.textColor = [UIColor colorWithWhite:0.369 alpha:1.000];
    }
    return _couponNameLabel;
}

- (UILabel *)couponNumberLabel
{
    if (!_couponNumberLabel) {
        _couponNumberLabel = [[UILabel alloc] init];
        _couponNumberLabel.font = [UIFont systemFontOfSize:14];
        _couponNumberLabel.textColor = [UIColor colorWithWhite:0.169 alpha:1.000];
    }
    return _couponNumberLabel;
}

- (UILabel *)couponStateLabel
{
    if (!_couponStateLabel) {
        _couponStateLabel = [[UILabel alloc] init];
        _couponStateLabel.font = [UIFont systemFontOfSize:14];
        _couponStateLabel.textColor = [UIColor colorWithRed:0.890 green:0.361 blue:0.082 alpha:1.000];
    }
    return _couponStateLabel;
}

@end
