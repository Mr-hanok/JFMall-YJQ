//
//  PersonalCenterMyFavoriteTableViewCell.m
//  CommunityApp
//
//  Created by iss on 8/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyFavoriteTableViewCell.h"
#import "UIImageView+AFNetworking.h"


@interface PersonalCenterMyFavoriteTableViewCell()
@property (strong,nonatomic) IBOutlet UIView* bg;
@property (strong,nonatomic) IBOutlet UIImageView* icon;
@property (strong,nonatomic) IBOutlet UILabel* text;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@end
@implementation PersonalCenterMyFavoriteTableViewCell

- (void)awakeFromNib {
    [self initCellStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


// 加载Cell数据
- (void)loadCellData:(Favorite *)fav
{
    //添加图片
    NSURL *url = [NSURL URLWithString:[Common setCorrectURL:fav.picUrl]];
    [self.icon setImageWithURL:url placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    
    //设置商品名
    [self.text setText:fav.goodsName];
    [self.amount setText:[NSString stringWithFormat:@"￥%@",fav.salePrice]];
}

- (void)initCellStyle {
    CALayer *layer =  self.bg.layer;
    layer.cornerRadius = 5;
    layer.borderWidth = 1;
    layer.borderColor = Color_Gray_RGB.CGColor;
    layer.masksToBounds = YES;
}
@end
