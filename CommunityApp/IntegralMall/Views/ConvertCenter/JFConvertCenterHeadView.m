//
//  ConvertCenterHeadView.m
//  CommunityApp
//
//  Created by yuntai on 16/4/22.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFConvertCenterHeadView.h"

@implementation JFConvertCenterHeadView

- (void)awakeFromNib {
    // Initialization code
}
- (void)inistallAdViewWithUrlArray:(NSMutableArray *)array
                           section:(NSInteger)section
                             title:(NSString *)title{
    if (section == 0) {
        self.bannerViewHeightConstrain.constant = 130.f;
        self.adVIew.hidden = NO;
        ad = [AdView adScrollViewWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 129) imageLinkURL:array placeHoderImageName:@"AdSlideDefaultImg" pageControlShowStyle:UIPageControlShowStyleCenter];
        ad.adMoveTime = 2.5f;
        __weak typeof(self) weakself = self;
        ad.callBack = ^(NSInteger index,NSString * imageURL)
        {
            weakself.adImagecallBack(index,imageURL);
        };
        [self.adVIew addSubview:ad];

    }else{

        [ad removeFromSuperview];
        self.adVIew.hidden = YES;
        self.bannerViewHeightConstrain.constant = 0.f;
    }
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
}

@end
