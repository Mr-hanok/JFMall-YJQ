//
//  SXUIButtonAdditions.h
//  TPO
//
//  Created by SunX on 14-5-20.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClickCallback)(UIButton* button);

@interface UIButton (ComUIButtonAdditions)

- (void)comHandleClickEvent:(UIControlEvents)aEvent
               callBack:(ButtonClickCallback)callBack;

@end
