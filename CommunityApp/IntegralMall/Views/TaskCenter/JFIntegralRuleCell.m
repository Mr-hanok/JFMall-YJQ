//
//  JFIntegralRuleCell.m
//  CommunityApp
//
//  Created by yuntai on 16/5/6.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFIntegralRuleCell.h"

@implementation JFIntegralRuleCell
+ (JFIntegralRuleCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath {
    
    JFIntegralRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JFIntegralRuleCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JFIntegralRuleCell class]) owner:nil options:0]lastObject];
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
- (void)configCellWithDic:(NSDictionary *)dic{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.questionLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
    
    
    NSString *logInfo = [dic objectForKey:@"content"];
    NSString  *msg;
    if ([logInfo rangeOfString:@"|"].length>0) {
        msg = [NSString stringWithFormat:@"%@",[logInfo stringByReplacingOccurrencesOfString:@"|" withString:@" \r\n" ]];
    }else{
        msg = logInfo;
    }

    self.answerLabel.text = [NSString stringWithFormat:@"%@",msg];
}
+ (CGFloat)heightOfCellWithText:(NSString *)str{
    
    NSString  *msg;
    if ([str rangeOfString:@"|"].length>0) {
        msg = [NSString stringWithFormat:@"%@",[str stringByReplacingOccurrencesOfString:@"|" withString:@" \r\n" ]];
    }else{
        msg = str;
    }
    
    CGFloat height = [Common labelDemandHeightWithText:msg font:[UIFont systemFontOfSize:15] size:CGSizeMake(APP_SCREEN_WIDTH-30, 1000)]+67;
    return height;
}

@end
