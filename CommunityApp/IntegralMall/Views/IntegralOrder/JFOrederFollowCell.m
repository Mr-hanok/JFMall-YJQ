//
//  JFOrederFollowCell.m
//  CommunityApp
//
//  Created by yuntai on 16/5/4.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFOrederFollowCell.h"

@implementation JFOrederFollowCell

+ (JFOrederFollowCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath{
    
    JFOrederFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JFOrederFollowCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JFOrederFollowCell" owner:nil options:0]lastObject];
    }
    
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configCellWith:(NSDictionary *)dic{
    if (self.indexPath.row == 0) {
        self.upLine.hidden = YES;
        self.stateImageIV.image = [UIImage imageNamed:@"jf-followgrayorange"];
    }else{
        self.upLine.hidden = NO;
        self.stateImageIV.image = [UIImage imageNamed:@"jf-followgray"];
    }
    self.timeLabel.text = [dic objectForKey:@"add_time"];
    self.stateLabel.numberOfLines = 0;
    
    NSString *logInfo = [dic objectForKey:@"log_info"];
    if ([logInfo rangeOfString:@"|"].length>0) {
        NSString  *msg;
        msg = [NSString stringWithFormat:@"%@",[logInfo stringByReplacingOccurrencesOfString:@"|" withString:@" \r\n" ]];
        self.stateLabel.text = msg;
    }else{
        self.stateLabel.text = logInfo;
    }
    
}
+ (CGFloat)heightOfCellWithText:(NSString *)str{
    NSString  *msg;
    if ([str rangeOfString:@"|"].length>0) {
        
        msg = [NSString stringWithFormat:@"%@",[str stringByReplacingOccurrencesOfString:@"|" withString:@" \r\n" ]];
        
    }else{
        msg = str;
    }

    
    CGFloat height = [Common labelDemandHeightWithText:msg font:[UIFont systemFontOfSize:15] size:CGSizeMake(APP_SCREEN_WIDTH-80, 1000)]+55;
    return height;
}


@end
