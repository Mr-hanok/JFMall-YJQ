//
//  UITableViewCell+PersonCenterMeCell.m
//  CommunityApp
//
//  Created by iss on 6/4/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMeCell.h"
@interface   PersonalCenterMeCell()

@property(strong,nonatomic)IBOutlet UIImageView* icon;
@property(strong,nonatomic)IBOutlet UILabel* label;
@property(strong,nonatomic)IBOutlet UIButton* sweag;
@property(strong,nonatomic)IBOutlet UIImageView* bottomImg;
@property(strong,nonatomic)IBOutlet UIImageView* bottomImg1;
@end
@implementation   PersonalCenterMeCell

- (void)awakeFromNib {
    [Common updateLayout:_bottomImg1 where:NSLayoutAttributeHeight constant:0.5];
}

-(void)setIconPath:(NSString *)path
{
    UIImage* image = [UIImage imageNamed:path];//加载入图片
    [self.icon setImage:image];
}
-(void)setName:(NSString *)name isBottom:(BOOL) isBottom
{
    [self.label setText:name];
    if(isBottom)
    {
        [_bottomImg setHidden:YES];
        [_bottomImg1 setHidden:NO];
    }
    else{
        [_bottomImg setHidden:NO];
        [_bottomImg1 setHidden:YES];
    }
}

@end
