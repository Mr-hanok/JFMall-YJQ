//
//  FirstSectionHeaderCollectionReusableView.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/14.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstSectionHeaderCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *categoryName;

@property (nonatomic, copy) void(^headerClickBlock)(void);

@end
