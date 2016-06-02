//
//  CustomerServiceCenterCell.m
//  CommunityApp
//
//  Created by iss on 6/29/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "CustomerServiceCenterCollectionViewCell.h"
@interface CustomerServiceCenterCollectionViewCell()
@property (strong,nonatomic) IBOutlet UIImageView* icon;
@property (strong,nonatomic) IBOutlet UILabel* label;
@end
@implementation CustomerServiceCenterCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setCell:(NSArray*)array
{
    if([array count]==0 )
        return;
    UIImage* img = [UIImage imageNamed:[array objectAtIndex:0]];
    [_icon setImage:img];
    
    if ([array count]==3) {
         UIImage* imgPre = [UIImage imageNamed:[array objectAtIndex:1]];
        [_icon setHighlightedImage:imgPre];
        [_label setText:[array objectAtIndex:2]];
    }
    else
    {
         [_label setText:[array objectAtIndex:1]];
    }
    
    
}
@end
