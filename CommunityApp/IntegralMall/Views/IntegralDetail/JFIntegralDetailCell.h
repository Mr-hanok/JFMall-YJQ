//
//  JFIntegralDetailCell.h
//  CommunityApp
//
//  Created by yuntai on 16/4/28.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFIntegralLogModel.h"
@interface JFIntegralDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@property (strong, nonatomic) NSIndexPath *indexPath;

+ (JFIntegralDetailCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath;
- (void)configCellWithIntegralModel:(JFIntegralLogModel *)model;
@end
