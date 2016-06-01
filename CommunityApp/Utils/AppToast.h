//
//  AppToast.h
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ToastPositionCenter = 0,
    ToastPositionBottom
} ToastPosition;

@interface AppToast : UIView
{
    NSTimer *timer;
    UILabel *textLabel;
    UIView *backgroundView;
}

+(id)shareInstance;
-(void)showToastWith:(NSString *)text position:(ToastPosition)position;
-(void)hiddenToast;

@end