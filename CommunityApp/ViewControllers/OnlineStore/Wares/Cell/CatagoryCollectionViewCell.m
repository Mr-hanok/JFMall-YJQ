//
//  CatagoryCollectionViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CatagoryCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CatagoryCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *catagoryBtn;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryNameWidth;

@end

@implementation CatagoryCollectionViewCell

- (void)awakeFromNib {
//    CGFloat oneCategoryWidth = Screen_Width * 2.0 / 11.0;
//    CGFloat categoryNameHeight = oneCategoryWidth * 2.0 / 5.0;
//    _categoryNameWidth.constant = categoryNameHeight;
//    _categoryImgWidth.constant = (oneCategoryWidth - categoryNameHeight) * 3.0 / 4.0;
    if (IPhone4 || IPhone5) {
        [_categoryName setFont:[UIFont systemFontOfSize:13.0]];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [_catagoryBtn setSelected:selected];
    
    if (selected) {
        _categoryName.textColor = UIColorFromRGB(0xe87f30);
    }
    else {
        _categoryName.textColor = UIColorFromRGB(0x484848);
    }
}

// 加载Cell数据
- (void)loadCellData:(GoodWaresList *)model
{
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:model.goodsUrl]];
    [_categoryImg setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"CatagoryHouseGoodsNor"]];
    [_categoryName setText:model.gcName];
}

@end
