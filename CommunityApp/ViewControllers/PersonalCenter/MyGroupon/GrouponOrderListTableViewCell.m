//
//  GrouponOrderListTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/8/20.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponOrderListTableViewCell.h"
@interface GrouponOrderListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *grouponName;
@property (weak, nonatomic) IBOutlet UILabel *grouponNo;
@property (weak, nonatomic) IBOutlet UILabel *grouponState;


@end
@implementation GrouponOrderListTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 加载Cell数据
- (void)loadCellData:(ticketModel *)model withNum:(NSInteger)num
{
    [self.grouponName setText:[NSString stringWithFormat:@"团购券%ld", (long)num]];
    [self.grouponNo setText:model.ticketNo];
    [self.grouponState setText:@"未使用"];
}

@end
