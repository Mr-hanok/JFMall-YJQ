//
//  ShoppingCartTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/12.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ShoppingCartTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface ShoppingCartTableViewCell()
@property (retain, nonatomic) IBOutlet UIImageView *waresImgView;
@property (retain, nonatomic) IBOutlet UILabel *waresName;
@property (retain, nonatomic) IBOutlet UILabel *waresMoney;
@property (retain, nonatomic) IBOutlet UIView *cartView;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIImageView *topLine;


@end

@implementation ShoppingCartTableViewCell

- (void)awakeFromNib {

    // 初始化count button
    self.countBtn = [CartCountButton instanceCartButton];
    [self.cartView addSubview:self.countBtn];
    
    [Common updateLayout:_topLine where:NSLayoutAttributeHeight constant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

// 装载Cell数据
- (void)loadCellData:(ShopCartModel *)model
{
//    [self.checkBox setSelected:model.isSelected];
    
    [self.waresName setText: model.wsName];
    
    [self resetShowPrice:model];
    
    NSArray *picUrls = [model.picUrl componentsSeparatedByString:@","];
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:[picUrls objectAtIndex:0]]];
    [self.waresImgView setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];
    [self.countBtn.countTextField setText:[NSString stringWithFormat:@"%ld", model.count]];
    
    // 插入标签
    NSArray *waresStyles = [model.waresStyle componentsSeparatedByString:@","];
    [Common insertLabelForStrings:waresStyles toView:self.labelView andViewHeight:24.0 andMaxWidth:(Screen_Width-122) andLabelHeight:18.0 andLabelMargin:5 andAddtionalWidth:2 andFont:[UIFont systemFontOfSize:12.0] andBorderColor:[UIColor clearColor].CGColor andTextColor:COLOR_RGB(120, 120, 120)];
}

- (void)resetShowPrice:(ShopCartModel *)model {
    if ([model isUseSpecialOfferRight]) {
        [self.waresMoney setNewPrice:model.specialOfferPrice oldPrice:model.currentPrice];
    }
    else {
        [self.waresMoney setText: [NSString stringWithFormat:@"￥%@", model.currentPrice]];
    }
    
    NSString *totalPrice = [NSString stringWithFormat:@"¥%.2f",[model calculationTotlePrice]];
    [self.totalPrice setText:totalPrice];
}


// 自动设置checkbox状态
- (void)setCheckBoxSelected
{
    [self.checkBox setSelected:!self.checkBox.selected];
}

// 指定CheckBox选择状态
- (void)setCheckBoxSelectStatus:(BOOL)status
{
    [self.checkBox setSelected:status];
}

// CheckBox点击事件处理函数
- (IBAction)checkBoxClickHandler:(id)sender
{
    [self.checkBox setSelected:!self.checkBox.selected];
    if (self.checkBoxStatusChangeBlock) {
        self.checkBoxStatusChangeBlock(self.checkBox.selected);
    }
}

@end
