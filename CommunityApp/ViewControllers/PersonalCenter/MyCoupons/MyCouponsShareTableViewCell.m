//
//  MyCouponsShareTableViewCell.m
//  CommunityApp
//
//  Created by iss on 8/10/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "MyCouponsShareTableViewCell.h"
@interface MyCouponsShareTableViewCell()
@property (strong,nonatomic) IBOutlet UIImageView* check;
@property (strong,nonatomic) IBOutlet UILabel* index;
@property (strong,nonatomic) IBOutlet UILabel* title;
@end
@implementation MyCouponsShareTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [_check setHidden:selected?FALSE:TRUE];
}
-(void)loadCellData:(NSInteger)index title:(NSString*)title
{
    [_index setText:[NSString stringWithFormat:@"团购券%ld",index]];
    [_title setText:title];
}
@end
