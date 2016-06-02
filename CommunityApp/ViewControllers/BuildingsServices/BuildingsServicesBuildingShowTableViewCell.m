//
//  BuildingsServicesBuildingShowTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/7/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BuildingsServicesBuildingShowTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface BuildingsServicesBuildingShowTableViewCell()
@property (retain,nonatomic) IBOutlet UIImageView *buildingImg;
@property (retain,nonatomic) IBOutlet UILabel *nameLabel;
@property (retain,nonatomic) IBOutlet UILabel *regionLabel;
@property (retain,nonatomic) IBOutlet UILabel *areaLabel;
@property (retain,nonatomic) IBOutlet UILabel *amountLabel;
@property (retain,nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation BuildingsServicesBuildingShowTableViewCell

- (void)awakeFromNib {
    // 设置statusLabel样式
    {
        _statusLabel.layer.borderWidth = 0.5;
        _statusLabel.layer.cornerRadius = 4;
        _statusLabel.layer.borderColor = [UIColor colorWithRed:236/255.0 green:68/255.0 blue:17/255.0 alpha:1].CGColor;
        _statusLabel.layer.backgroundColor =[UIColor whiteColor].CGColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadCellData:(BuildingSnapModel *)model  {
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:model.pic]];
    [self.buildingImg setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    [self.nameLabel setText:model.projectName];
    [self.regionLabel setText:model.plate];
    [self.areaLabel setText:model.areaName];
    
    if(![model.averagePrice  isEqual: @""]) {
        [_amountLabel setText:[NSString stringWithFormat:@"￥%@",model.averagePrice]];
    }else {
        [_amountLabel setText:@"暂无报价"];
    }
    
    if (![model.salesStatusName  isEqual: @""]) {
        _statusLabel.hidden = FALSE;
        [self.statusLabel setText:model.salesStatusName];
    }else {
        _statusLabel.hidden = TRUE;
    }
}

@end
