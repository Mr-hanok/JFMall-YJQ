//
//  HousesServicesBuildingsTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "HousesServicesBuildingsTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface HousesServicesBuildingsTableViewCell()
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *areaLabel;
@property (nonatomic,weak) IBOutlet UILabel *amountLabel;
@property (nonatomic,weak) IBOutlet UIImageView *thumbImageView;
@property (nonatomic,weak) IBOutlet UILabel *certLabel;
@end

@implementation HousesServicesBuildingsTableViewCell


- (void)awakeFromNib {
    {   //设置certLabel标签样式
        _certLabel.layer.borderWidth = 0.5;
        _certLabel.layer.cornerRadius = 4;
        _certLabel.layer.borderColor = [UIColor colorWithRed:236/255.0 green:68/255.0 blue:17/255.0 alpha:1].CGColor;
        _certLabel.layer.backgroundColor =[UIColor whiteColor].CGColor;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)loadCellData:(HouseListModel *)model {
    [self.nameLabel setText:model.projectName];
    [self.areaLabel setText:model.areaName];
    
    if ([model.price isEqual: @"null"]) {
        [self.amountLabel setText:@"暂无报价"];
    }else{
        [self.amountLabel setText:model.price];
    }
    
    NSURL *iconUrl = [NSURL URLWithString:model.picPath];
    [self.thumbImageView setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    
    if ([model.propertyInhandeName  isEqual: @""]) {
        [self.certLabel setHidden:TRUE];
    }else{
        [self.certLabel setHidden:FALSE];
        [self.certLabel setText:model.propertyInhandeName];
    }
    
}

@end
