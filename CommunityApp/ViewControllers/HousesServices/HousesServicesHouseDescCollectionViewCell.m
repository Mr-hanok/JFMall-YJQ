//
//  HousesServicesHouseDescCollectionViewCell.m
//  CommunityApp
//
//  Created by iss on 7/3/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HousesServicesHouseDescCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface HousesServicesHouseDescCollectionViewCell()
@property (strong,nonatomic) IBOutlet UIImageView* img;
@end

@implementation HousesServicesHouseDescCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void) loadCellData:(NSString*)urlImg
{
    NSURL *iconUrl = [NSURL URLWithString:urlImg];
    [self.img setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
}
@end
