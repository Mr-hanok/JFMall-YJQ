//
//  JFTaskCenterCell.h
//  CommunityApp
//
//  Created by yuntai on 16/4/25.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTasKCenterModel.h"
/**
 *  任务中心cell
 */
@interface JFTaskCenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;//积分
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;//进度

@property (strong, nonatomic) NSIndexPath *indexPath;

+ (JFTaskCenterCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath;
- (void)configCellDataWithModel:(JFTasKCenterModel *)model;
@end
