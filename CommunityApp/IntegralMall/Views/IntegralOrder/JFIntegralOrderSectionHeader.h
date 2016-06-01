//
//  JFIntegralOrderSectionHeader.h
//  CommunityApp
//
//  Created by yuntai on 16/5/4.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFIntegralOrderSectionHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (void)configSectionHeaderWith;
@end
