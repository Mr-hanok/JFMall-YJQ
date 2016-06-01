//
//  ManJianFooterView.h
//  CommunityApp
//
//  Created by yuntai on 16/4/15.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  满减尾部 活动说明
 */
@interface ManJianFooterView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
- (NSInteger)loadFooterText:(NSString *)str;
@end
