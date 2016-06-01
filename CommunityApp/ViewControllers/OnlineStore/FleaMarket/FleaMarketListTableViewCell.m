//
//  FleaMarketListTableViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "FleaMarketListTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface FleaMarketListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *waresImg;
@property (weak, nonatomic) IBOutlet UILabel *waresTitle;
@property (weak, nonatomic) IBOutlet UILabel *waresPrice;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *publishTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waresTitleHight;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;


@end

@implementation FleaMarketListTableViewCell

- (void)awakeFromNib {
    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellData:(FleaCommodityListModel*)listModel
{
    [_waresTitle setText:listModel.title];
    CGFloat height = [Common labelDemandHeightWithText:_waresTitle.text font:_waresTitle.font size:CGSizeMake(_waresTitle.bounds.size.width, 2000)];
    _waresTitleHight.constant = height;
    [_waresPrice setText:[NSString stringWithFormat:@"￥%@",listModel.price]];

    if (listModel.picture != nil && listModel.picture.length > 0) {
        NSArray *pictures = [listModel.picture componentsSeparatedByString:@","];
        NSString *picUrl = [pictures firstObject];
        [_waresImg setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    }else {
        [_waresImg setImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    }

    [_address setText:listModel.positionName];
    [_publishTime setText:listModel.createTime];
}
@end
