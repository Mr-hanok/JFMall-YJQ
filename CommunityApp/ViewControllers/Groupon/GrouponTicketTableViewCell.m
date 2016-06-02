//
//  GrouponTicketTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/8/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponTicketTableViewCell.h"
@interface GrouponTicketTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *grouponTicketId;
@property (weak, nonatomic) IBOutlet UILabel *grouponTicketNo;
@end
@implementation GrouponTicketTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)loadCellData:(ticketModel *)ticket forRow:(NSInteger)row {
    [_grouponTicketId setText:[NSString stringWithFormat:@"团购券%ld", row + 1]];
    [_grouponTicketNo setText:[NSString stringWithFormat:@"%@", ticket.ticketNo]];
}
@end
