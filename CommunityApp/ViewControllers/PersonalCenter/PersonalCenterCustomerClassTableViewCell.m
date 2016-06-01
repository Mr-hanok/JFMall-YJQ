//
//  PersonalCenterCustomerClassTableViewCell.m
//  CommunityApp
//
//  Created by iss on 6/12/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterCustomerClassTableViewCell.h"
@interface PersonalCenterCustomerClassTableViewCell()
@property(strong,nonatomic)IBOutlet UILabel* label;

@end
@implementation PersonalCenterCustomerClassTableViewCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setText:(NSString *)text
{
    [self.label setText:text];
}

-(NSString*)getText
{
    return self.label.text;
}
@end
