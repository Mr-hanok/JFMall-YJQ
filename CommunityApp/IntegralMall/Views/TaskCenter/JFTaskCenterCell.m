//
//  JFTaskCenterCell.m
//  CommunityApp
//
//  Created by yuntai on 16/4/25.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFTaskCenterCell.h"

@implementation JFTaskCenterCell
+ (JFTaskCenterCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath {
    
    JFTaskCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JFTaskCenterCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JFTaskCenterCell class]) owner:nil options:0]lastObject];
    }
    
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)configCellDataWithModel:(JFTasKCenterModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"%@(+%@)",model.missionName,model.integral];
    self.integralLabel.text = [NSString stringWithFormat:@"%@",model.totalIntegral];
    self.progressLabel.text = [NSString stringWithFormat:@"%@",@""];
    if ([model.isFinish isEqualToString:@"0"]) {//未完成
        self.progressLabel.text = @"未完成";
    }
    if ([model.isFinish isEqualToString:@"1"]) {//一次性任务
        self.progressLabel.text = @"";
    }
    if ([model.isFinish isEqualToString:@"2"]) {//已完成
        self.progressLabel.text = @"已完成";
//        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
}


@end
