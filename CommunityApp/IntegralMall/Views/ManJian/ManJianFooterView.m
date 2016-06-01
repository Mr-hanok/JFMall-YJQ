//
//  ManJianFooterView.m
//  CommunityApp
//
//  Created by yuntai on 16/4/15.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "ManJianFooterView.h"

@implementation ManJianFooterView

- (void)awakeFromNib {
    // Initialization code
}
- (NSInteger)loadFooterText:(NSString *)str{
    self.descriptionLabel.text = str;
    self.descriptionLabel.backgroundColor = Color_Comm_AppBackground;
    CGFloat height = [Common labelDemandHeightWithText:str font:[UIFont systemFontOfSize:12] size:CGSizeMake(APP_SCREEN_WIDTH-50, 1200)]+50;
    return height;
}
@end
