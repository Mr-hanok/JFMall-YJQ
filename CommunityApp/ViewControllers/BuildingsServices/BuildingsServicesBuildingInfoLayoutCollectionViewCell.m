//
//  BuildingsServicesBuildingInfoLayoutCollectionViewCell.m
//  CommunityApp
//
//  Created by iss on 7/3/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BuildingsServicesBuildingInfoLayoutCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface BuildingsServicesBuildingInfoLayoutCollectionViewCell()
@property (strong,nonatomic) IBOutlet UIImageView* img;
@property (strong,nonatomic) IBOutlet UILabel* text;
@end

@implementation BuildingsServicesBuildingInfoLayoutCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [_img.layer  setCornerRadius:3];
    [_img.layer setBorderWidth:0.5f];
    [_img.layer setBorderColor:[UIColor colorWithRed:212.0/255 green:212.0/255 blue:212.0/255.0 alpha:1].CGColor];
    [_img.layer setBackgroundColor:[UIColor colorWithRed:212.0/255 green:212.0/255 blue:212.0/255.0 alpha:1].CGColor];
}
-(void)loadCellData:(NSString*)imgUrl apartmentName:(NSString*)apartmentName
{
    NSURL *url = [NSURL URLWithString:[Common setCorrectURL:imgUrl]];
    [_img setImageWithURL:url placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    [_text setText:apartmentName];
}
@end
