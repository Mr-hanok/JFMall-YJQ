//
//  AppToast.m
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AppToast.h"
#import <Masonry.h>

@implementation AppToast

#pragma mark - ShareInstance
+(id)shareInstance
{
    static id shareInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:[UIColor blackColor]];
        [backgroundView setAlpha:0.6];
        [backgroundView.layer setCornerRadius:5];
        [self addSubview:backgroundView];

        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.left.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
        }];
        
        
        textLabel = [[UILabel alloc] init];
        [textLabel setTextColor:[UIColor whiteColor]];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [self addSubview:textLabel];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.left.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
        }];
    }
    
    return self;
}

-(void)showToastWith:(NSString *)text position:(ToastPosition)position
{
    [textLabel setText:text];
    
    BOOL isShowing = NO;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [Common labelDemandRectWithText:text font:textLabel.font size:CGSizeMake(Screen_Width, Screen_Height)];
    
    for (AppToast *toast in window.subviews)
    {
        if ([toast isKindOfClass:[AppToast class]])
        {
            isShowing = YES;
        }
    }
    
    if (!isShowing)
    {
        [self setAlpha:0.0];
        [window addSubview:self];
    }
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(window).offset(-60);
        make.centerX.mas_equalTo(window.mas_centerX);
        make.height.mas_equalTo(rect.size.height + 10);
        make.width.mas_equalTo(rect.size.width + 20);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:1.0];
    }completion:^(BOOL finished) {
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(hiddenToast) userInfo:nil repeats:NO];
    }];
}

-(void)hiddenToast
{
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end