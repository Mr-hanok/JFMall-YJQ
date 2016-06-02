//
//  CommunityServiceCollectionViewCell.m
//  CommunityApp
//
//  Created by Andrew on 15/11/6.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "CommunityServiceCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface CommunityServiceCollectionViewCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CommunityServiceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
    }
    [self setNeedsUpdateConstraints];
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(8);
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.height.equalTo(@TPDXLABHEIBOTTOM);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(TPDXLABBOTTOM);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(TPDXIMGTOP);
        make.bottom.equalTo(self.titleLabel.mas_top).with.offset(TPDXIMGBOTTOM);
        make.width.equalTo(self.iconImageView.mas_height).multipliedBy(1.0f);
    }];
}

// 为Cell装载数据
- (void)loadCellData:(NSArray*)array
{
        [self.iconImageView setImage:[UIImage imageNamed:[array objectAtIndex:0]]];
        [self.iconImageView setHighlightedImage:[UIImage imageNamed:[array objectAtIndex:1]]];
        [self.titleLabel setText:[array objectAtIndex:2]];
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:95.0/255 green:95.0/255 blue:95.0/255 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


@end
