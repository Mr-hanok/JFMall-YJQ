//
//  LifeSupermarketTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "LifeSupermarketTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface LifeSupermarketTableViewCell()

    @property (retain, nonatomic) IBOutlet UIImageView *marketPicUrl;
    @property (retain, nonatomic) IBOutlet UILabel *marketName;
    @property (retain, nonatomic) IBOutlet UILabel *address;
    @property (retain, nonatomic) IBOutlet UILabel *distance;

@end

@implementation LifeSupermarketTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 装载Cell数据
- (void)loadCellData:(SurroundBusinessModel *)model
{
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:model.businessPicUrl]];
    [self.marketPicUrl setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    [self.marketName setText:model.businessName];
    // [self.phone setText:model.phone];
    [self.address setText:model.address];
    [self.distance setText:model.distance];
}

// 打电话接口
- (IBAction)clickCallMe:(id)sender {
    if ([_delegate respondsToSelector:@selector(marketCell:)]) {
        [_delegate marketCell:self];
    }
}
@end
