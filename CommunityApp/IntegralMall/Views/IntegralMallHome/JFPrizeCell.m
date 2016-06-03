//
//  JFPrizeCell.m
//  CommunityApp
//
//  Created by yuntai on 16/6/2.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFPrizeCell.h"
#import <UIImageView+WebCache.h>

@implementation JFPrizeCell
+ (JFPrizeCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath prize_type:(NSString *)prize_type{
    
    JFPrizeCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    JFPrizeCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    
    if ([prize_type isEqualToString:@"2"]) {//积分奖
        if (!cell1) {
            cell1 = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JFPrizeCell class]) owner:nil options:0]firstObject];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.indexPath = indexPath;
        
        return cell1;

    }
    if ([prize_type isEqualToString:@"1"]) {//实物奖
        if (!cell2) {
            cell2 = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JFPrizeCell class]) owner:nil options:0]lastObject];
        }
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        cell2.indexPath = indexPath;

        return cell2;
    }
    
    return nil;
    
}
+ (CGFloat)cellHeigthWithModel:(JFPrizeModel *)model{
    CGFloat height = 0.f;
    if ([model.prize_type isEqualToString:@"2"]) {
        height = 45;
    }else{
        height = 90;
    }
    return height;
}

- (void)configCellWithModel:(JFPrizeModel *)model{
    self.model = model;
    if ([model.prize_type isEqualToString:@"2"]) {//积分奖
        self.integralLabel.text = model.prize_name;
        self.time1Label.text = model.time;
        if ([model.award_status isEqualToString:@"1"]) {
            [self.state1Btn setTitle:@"已领取" forState:UIControlStateNormal];
            [self.state1Btn setBackgroundColor:HEXCOLOR(0xd9d9d9)];
        }else{
            [self.state1Btn setTitle:@"未领取" forState:UIControlStateNormal];
            [self.state1Btn setBackgroundColor:HEXCOLOR(0xDD6848)];
        }
        
    }else{//实物奖
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:model.goods_pic] placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];
        self.goodsNameLabel.text = model.prize_name;
        self.goodsSpecLabel.text = @"";
        self.time2Label.text = model.time;
        if ([model.award_status isEqualToString:@"1"]) {
            [self.state2Btn setTitle:@"已领取" forState:UIControlStateNormal];
            [self.state2Btn setBackgroundColor:HEXCOLOR(0xd9d9d9)];

        }else{
            [self.state2Btn setTitle:@"未领取" forState:UIControlStateNormal];
            [self.state2Btn setBackgroundColor:HEXCOLOR(0xDD6848)];
        }
    }
    
}
- (void)awakeFromNib {
    // Initialization code
    self.state1Btn.layer.cornerRadius = 5.f;
    self.state1Btn.layer.masksToBounds = YES;
    self.state2Btn.layer.cornerRadius = 5.f;
    self.state2Btn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)state1BtnClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"未领取"]) {
        self.callBackPrize(self.model.pid,@"2");
    }
}

- (IBAction)state2BtnClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"未领取"]) {
        self.callBackPrize(self.model.pid,@"1");
    }
}
@end
