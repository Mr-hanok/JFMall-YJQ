//
//  JFIntegralDetailCell.m
//  CommunityApp
//
//  Created by yuntai on 16/4/28.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFIntegralDetailCell.h"

@implementation JFIntegralDetailCell
+ (JFIntegralDetailCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath {
    
    JFIntegralDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JFIntegralDetailCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JFIntegralDetailCell class]) owner:nil options:0]lastObject];
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
- (void)configCellWithIntegralModel:(JFIntegralLogModel *)model{
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.source];
    NSString *time = [model.addTime substringToIndex:16];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",time];
    self.integralLabel.text = [NSString stringWithFormat:@"%@",model.integralVal];

}
@end
