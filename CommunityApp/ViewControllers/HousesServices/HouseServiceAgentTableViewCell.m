//
//  BuildingsServicesBuildingShowTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/7/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "HouseServiceAgentTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface HouseServiceAgentTableViewCell()
@property (retain,nonatomic) IBOutlet UIImageView *BuildingImg;
@property (retain,nonatomic) IBOutlet UILabel *nameLabel;
@property (retain,nonatomic) IBOutlet UILabel *regionLabel;
@property (retain,nonatomic) IBOutlet UILabel *areaLabel;
@property (retain,nonatomic) IBOutlet UILabel *amountLabel;
@property (retain,nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation HouseServiceAgentTableViewCell

- (void)awakeFromNib {
    _statusLabel.layer.borderWidth = 0.5;
    _statusLabel.layer.cornerRadius = 4;
    _statusLabel.layer.borderColor = [UIColor colorWithRed:236/255.0 green:68/255.0 blue:17/255.0 alpha:1].CGColor;
    _statusLabel.layer.backgroundColor =[UIColor whiteColor].CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadCellData:(HouseListModel*)model  {
 
    [_nameLabel setText: model.projectName];
    [_areaLabel setText:[NSString stringWithFormat:@"%@ %@㎡",model.roomTypeName,model.houseSize]];
    [_regionLabel setText:model.areaName];
    NSString* priceText;
    if([model.recordType isEqualToString:@"2"])
    {
        priceText = [NSString stringWithFormat:@"￥%@元/㎡",model.price];

    }
    else
    {
        if ([model.priceType isEqualToString:@"2"])
        {
            priceText = [NSString stringWithFormat:@"￥%@元/月",model.price];
        }
        else
        {
            priceText = [NSString stringWithFormat:@"￥%@元/天",model.price];
        }
    }
   
    [_amountLabel setText:priceText];
    NSString* stateText = @"租房";
    if ([model.recordType isEqualToString:@"2"]) {
        stateText = @"在售";
    }
    [_statusLabel setText:stateText];
    NSURL* url = [[NSURL alloc]initWithString:[Common setCorrectURL:model.picPath]];
    [_BuildingImg setImageWithURL:url placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    
}

@end
