//
//  PersonalCenterIntegralRuleTableViewCell.m
//  CommunityApp
//
//  Created by iss on 8/26/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterIntegralRuleTableViewCell.h"
@interface PersonalCenterIntegralRuleTableViewCell()
@property (strong,nonatomic) IBOutlet UILabel* level;
@property (strong, nonatomic) IBOutlet UILabel *minIntegral;
@end
@implementation PersonalCenterIntegralRuleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellData:(integralRulesModel*)rule
{
    [_level setText:[NSString stringWithFormat:@"等级:     %@",rule.membersLevel]];
     [_minIntegral setText:[NSString stringWithFormat:@"需要积分达到:     %@",rule.minimumScore]];
 
}
@end
