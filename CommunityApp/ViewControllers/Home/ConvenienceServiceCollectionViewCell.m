//
//  ConvenienceServiceCollectionViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//


#import "ConvenienceServiceCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface ConvenienceServiceCollectionViewCell ()
@property (nonatomic, retain) IBOutlet UIImageView *icon;
@property (nonatomic, retain) IBOutlet UILabel *title;

@end


@implementation ConvenienceServiceCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}


/* 装载Cell数据
 * @parameter:array 需要包含两个数据，第一个为图像名，第二个为Title
 */
- (void)loadCellData:(ServiceList *)model
{
    if ([model.serviceId isEqualToString:ServiceID_HouseRepair]) {
        [self.icon setImage:[UIImage imageNamed:Img_Home_HouseRepair_More]];
        [self.title setText:Str_Service_HouseRepair];
    }else if ([model.serviceId isEqualToString:ServiceID_PipeClean]) {
        [self.icon setImage:[UIImage imageNamed:Img_Home_PipeClean_More]];
        [self.title setText:Str_Service_PipeClean];
    }else if ([model.serviceId isEqualToString:ServiceID_WaterElectricRepair]) {
        [self.icon setImage:[UIImage imageNamed:Img_Home_WaterElectricRepair_More]];
        [self.title setText:Str_Service_WaterElectricRepair];
    }else if ([model.serviceId isEqualToString:ServiceID_HardWareFitting]) {
        [self.icon setImage:[UIImage imageNamed:Img_Home_HardWareFitting]];
        [self.title setText:Str_Service_HardWareFitting];
    }else {
        NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:model.serviceLogoUrl]];
        [self.icon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
        [self.title setText:model.serviceName];
    }
}


/* 装载Cell数据
 */
- (void)loadCellDataForMore
{
    [self.title setText:Str_Comm_More];
    [self.icon setImage:[UIImage imageNamed:Img_Home_More]];
}

@end
