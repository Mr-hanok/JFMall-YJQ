//
//  HeaderCollectionReusableView.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *clicksMore;
@property (weak, nonatomic) IBOutlet UIImageView *topLine;
@property (weak, nonatomic) IBOutlet UIView *tipLine;

@property (nonatomic, copy)void (^headerClickBlock)(void);

- (void)setTitle:(NSString *)title atIndex:(NSInteger)index;

@end
