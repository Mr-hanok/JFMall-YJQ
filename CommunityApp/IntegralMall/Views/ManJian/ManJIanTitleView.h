//
//  ManJIanTitleView.h
//  CommunityApp
//
//  Created by yuntai on 16/4/15.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  满减头部视图
 */
@interface ManJIanTitleView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headIVHeight;

- (void)loadHeadersection:(NSInteger)section
                imagePath:(NSString *)headImage
         placeHolderImage:(NSString *)placeHolderImage
                    title:(NSString *)title;
@end
