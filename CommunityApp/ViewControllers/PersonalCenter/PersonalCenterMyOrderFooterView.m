//
//  PersonalCenterMyOrderFooterView.m
//  CommunityApp
//
//  Created by iss on 7/8/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderFooterView.h"
@interface PersonalCenterMyOrderFooterView()
@property (strong,nonatomic) IBOutlet UIImageView* seperatorLine;
@property (strong,nonatomic) IBOutlet UIButton* btnLeft;
@property (strong,nonatomic) IBOutlet UIButton* btnFix;
@property (strong,nonatomic) IBOutlet UIButton* trackFix;
@property (strong,nonatomic) IBOutlet UIImageView* imgBottom;
@property (strong,nonatomic) IBOutlet UIView* bg;
@property (strong,nonatomic) IBOutlet UIImageView* imgButtom;
@end
@implementation PersonalCenterMyOrderFooterView

- (void)viewWillAppear {
    self.fixbtn = _btnFix;
    YjqLog(@"ggghgh");
}

-(void)setViewWithTag:(NSInteger)tag
{
    self.btnFix.tag = tag;
    self.btnLeft.tag = tag;
    self.trackFix.tag = tag;
}
-(void)setBtnArray:(NSArray *)btnArray
{

    if (btnArray.count ==0) {
        [_btnLeft setHidden:TRUE];
        [_btnFix setHidden:TRUE];
        [_trackFix setHidden:TRUE];
        return;
    }
    
    [self.btnFix.layer setBorderWidth:1];
    [self.btnFix.layer setCornerRadius:5];

    NSDictionary* fix = [btnArray objectAtIndex:0];
    NSString* text = [fix objectForKey:@"text"];
    NSString* function = [fix objectForKey:@"function"];
    [self.btnFix setTitle:text forState:UIControlStateNormal];
     [self setBtnColor:self.btnFix];
    [self.btnFix removeTarget:self.delegate
                       action:NULL
             forControlEvents:UIControlEventTouchUpInside];
    if ([function isEqualToString:@""]==FALSE && self.delegate && [self.delegate respondsToSelector:NSSelectorFromString(function)]) {
           [self.btnFix addTarget:self.delegate action:NSSelectorFromString(function) forControlEvents:UIControlEventTouchUpInside];
    }
    if (btnArray.count == 1) {
        [_btnLeft setHidden:TRUE];
        [_trackFix setHidden:TRUE];
        return;
    }
    
    [self.btnLeft.layer setBorderWidth:1];
    [self.btnLeft.layer setCornerRadius:5];

    NSDictionary* left = [btnArray objectAtIndex:1];
    [_btnLeft setHidden:NO];
    text = [left objectForKey:@"text"];
    function = [left objectForKey:@"function"];
    [self.btnLeft setTitle:text forState:UIControlStateNormal];
    [self.btnLeft removeTarget:self.delegate
                       action:NULL
             forControlEvents:UIControlEventTouchUpInside];
 
    if ([function isEqualToString:@""]==FALSE && self.delegate && [self.delegate respondsToSelector:NSSelectorFromString(function)]) {
        [self.btnLeft addTarget:self.delegate action:NSSelectorFromString(function) forControlEvents:UIControlEventTouchUpInside];
    }
    [self setBtnColor:self.btnLeft];
    
    if (btnArray.count == 2) {
        [_trackFix setHidden:TRUE];
        return;
    }
    
    [self.trackFix.layer setBorderWidth:1];
    [self.trackFix.layer setCornerRadius:5];
    
    NSDictionary* track = [btnArray objectAtIndex:2];
    [_trackFix setHidden:NO];
    text = [track objectForKey:@"text"];
    function = [track objectForKey:@"function"];
    [self.trackFix setTitle:text forState:UIControlStateNormal];
    [self.trackFix removeTarget:self.delegate
                        action:NULL
              forControlEvents:UIControlEventTouchUpInside];
    
    if ([function isEqualToString:@""]==FALSE && self.delegate && [self.delegate respondsToSelector:NSSelectorFromString(function)]) {
        [self.trackFix addTarget:self.delegate action:NSSelectorFromString(function) forControlEvents:UIControlEventTouchUpInside];
    }
    [self setBtnColor:self.trackFix];
}

-(void)setBtnColor:(UIButton*)btn
{
   
   
    if( [[btn currentTitle] isEqualToString:Str_Order_Accepted] || [[btn currentTitle] isEqualToString:Str_Order_ToPay])
    {
        [btn.layer setBackgroundColor:Color_Green_RGB.CGColor];
        [btn setTitleColor:Color_White_RGB forState:UIControlStateNormal];
        [btn.layer setBorderColor:Color_Green_RGB.CGColor];
    }
    else
    {
        [btn.layer setBorderColor:Color_Yellow_RGB.CGColor];
        [btn setTitleColor:Color_White_RGB forState:UIControlStateNormal];
        [btn.layer setBackgroundColor:Color_Yellow_RGB.CGColor];
    }
    
}

@end
