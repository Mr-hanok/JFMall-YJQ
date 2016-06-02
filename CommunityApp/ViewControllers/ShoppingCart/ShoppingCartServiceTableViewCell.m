//
//  ShoppingCartServiceTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/12.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ShoppingCartServiceTableViewCell.h"

@interface ShoppingCartServiceTableViewCell()
@property (retain, nonatomic) IBOutlet UIButton *checkBox;
@property (retain, nonatomic) IBOutlet UILabel *serviceName;
@property (retain, nonatomic) IBOutlet UILabel *servicePrice;
@property (retain, nonatomic) IBOutlet UILabel *serviceTime;
@property (retain, nonatomic) IBOutlet UILabel *serviceType;

@end

@implementation ShoppingCartServiceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

// 装载Cell数据
- (void)loadCellData:(ShopCartModel *)model
{
    [self.serviceName setText:model.wsName];
    [self.servicePrice setText:[NSString stringWithFormat:@"￥%@", model.currentPrice]];
    [self.serviceTime setText:model.serviceTime];
    if (model.appointmentType == 1) {
        [self.serviceType setText:@"即时服务"];
    }else {
        [self.serviceType setText:@"预约服务"];
    }
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
