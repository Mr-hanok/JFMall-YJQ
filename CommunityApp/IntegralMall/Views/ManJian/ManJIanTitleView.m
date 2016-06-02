//
//  ManJIanTitleView.m
//  CommunityApp
//
//  Created by yuntai on 16/4/15.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "ManJIanTitleView.h"
#import <UIImageView+WebCache.h>
@implementation ManJIanTitleView

- (void)awakeFromNib {
    // Initialization code
}
- (void)loadHeadersection:(NSInteger)section
                imagePath:(NSString *)headImage
         placeHolderImage:(NSString *)placeHolderImage
                    title:(NSString *)title{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:placeHolderImage]];
    self.titleLabel.text = title;
    if (section != 0) {
        self.headIVHeight.constant = 0 ;
        self.headImageView.image = nil;
        [self.headImageView removeFromSuperview];
    }
}
@end
