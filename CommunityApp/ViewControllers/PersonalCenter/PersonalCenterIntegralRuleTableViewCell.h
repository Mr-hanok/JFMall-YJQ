//
//  PersonalCenterIntegralRuleTableViewCell.h
//  CommunityApp
//
//  Created by iss on 8/26/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "integralRulesModel.h"

@interface PersonalCenterIntegralRuleTableViewCell : UITableViewCell
-(void)loadCellData:(integralRulesModel*)rule;
@end
