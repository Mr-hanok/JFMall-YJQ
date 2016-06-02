//
//  ConvertCenterHeadView.h
//  CommunityApp
//
//  Created by yuntai on 16/4/22.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
/**
 *  兑换中心headview
 */
@interface JFConvertCenterHeadView : UICollectionReusableView
{
    AdView *ad;
}
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstrain;
@property (weak, nonatomic) IBOutlet UIView *adVIew;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@property (nonatomic,strong) void (^adImagecallBack)(NSInteger index,NSString * imageURL);

- (void)inistallAdViewWithUrlArray:(NSMutableArray *)array
                           section:(NSInteger)section
                             title:(NSString *)title;
@end
