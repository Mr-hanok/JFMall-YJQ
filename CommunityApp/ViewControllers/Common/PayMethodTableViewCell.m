//
//  PayMethodTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/7/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "PayMethodTableViewCell.h"

@interface PayMethodTableViewCell()
@property (retain, nonatomic) IBOutlet UIImageView *payMethodIcon;
@property (retain, nonatomic) IBOutlet UILabel *payMethodName;
@end

@implementation PayMethodTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setPayMethodName:(NSString *)name setPayMethodIcon:(NSString *)icon {
    [self.payMethodName setText:name];
    [self.payMethodIcon setImage:[UIImage imageNamed:icon]];
}

//- (void)loadCellData:(WaresDetail *)model {
//    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:model.goodsUrl]];
//    [self.goodsIcon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"BusinessIcon"]];
//    [self.goodsName setText:model.goodsName];
//    [self.goodsDescription setText:model.goodsDescription];
//    [self.goodsPrice setText:model.goodsActualPrice];
//}

@end
