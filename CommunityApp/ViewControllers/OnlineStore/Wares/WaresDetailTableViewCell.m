//
//  WaresDetailTableViewCell.m
//  CommunityApp
//
//  Created by iss on 8/7/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "WaresDetailTableViewCell.h"

@implementation WaresDetailTableViewCell

- (void)awakeFromNib {
    [Common updateLayout:_topLine where:NSLayoutAttributeHeight constant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//加载Cell数据
- (void)loadCellData:(GoodsComment *)comment
{
    [self.commentDesc setText:comment.desc];
}

@end
