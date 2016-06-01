//
//  SurroundBusinessTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/7/31.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "SurroundChoiceTableViewCell.h"
#import "TQStarRatingView.h"
#import "UIImageView+AFNetworking.h"

@interface SurroundChoiceTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *businessImg;
@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel;
@property (weak, nonatomic) IBOutlet TQStarRatingView *tQStarRatingView;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@end

@implementation SurroundChoiceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadCellData:(SurroundBusinessModel *)model {
    _tQStarRatingView.isEdit = NO;
    
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:model.businessPicUrl]];
    [self.businessImg setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    [self.tQStarRatingView setScore:[model.score floatValue]/kNUMBER_OF_STAR withAnimation:TRUE];

    [self.businessNameLabel setText:model.businessName];
    
    if (![model.perConsumption isEqual: @""])
    {
        [self.amountLabel setText:[NSString stringWithFormat:@"￥%@",model.perConsumption]];
    }
    else
    {
        [self.amountLabel setText:@"无记录"];
    }

    [self.distanceLabel setText:model.distance];
}

- (IBAction)toCallHotLine:(id)sender {
    if (self.dialHotLineBlock) {
        self.dialHotLineBlock();
    }
}
@end
