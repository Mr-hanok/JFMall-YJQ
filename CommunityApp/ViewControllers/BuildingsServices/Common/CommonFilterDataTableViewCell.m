//
//  CommonFilterDataTableViewCell.m
//  CommunityApp
//
//  Created by iss on 7/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "CommonFilterDataTableViewCell.h"
@interface CommonFilterDataTableViewCell()
@property (strong,nonatomic) IBOutlet UILabel* label;
@end

@implementation CommonFilterDataTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellData:(NSString*)text
{
    [_label setText:text];
}
@end
