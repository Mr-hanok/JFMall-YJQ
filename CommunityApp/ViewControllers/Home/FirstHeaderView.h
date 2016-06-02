//
//  FirstHeaderView.h
//  CommunityApp
//
//  Created by issuser on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KDCycleBannerView.h>

@interface FirstHeaderView : UICollectionReusableView

@property (nonatomic, retain) IBOutlet KDCycleBannerView *cycleBannerView;

-(void)loadHeaderData:(NSArray *)adImgSildeInfoArray;

@property (nonatomic, copy) void(^adImgClickBlock)(NSUInteger index);

@property (nonatomic, copy) NSString    *defaultImgName;

@end
