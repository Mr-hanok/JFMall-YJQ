//
//  ComTableViewCell.m
//  CommonApp
//
//  Created by lipeng on 16/4/1.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComTableViewCell.h"

@implementation ComTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setItem:(id)item {
    _item = item;
}

@end
