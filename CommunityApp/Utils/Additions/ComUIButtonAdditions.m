//
//  SXUIButtonAdditions.m
//  TPO
//
//  Created by SunX on 14-5-20.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import "ComUIButtonAdditions.h"
#import <objc/runtime.h>

static char *overViewKey;

@implementation UIButton (ComUIButtonAdditions)

- (void)comHandleClickEvent:(UIControlEvents)aEvent
               callBack:(ButtonClickCallback)callBack;
{
    objc_setAssociatedObject(self, &overViewKey, callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(buttonClick) forControlEvents:aEvent];
}

- (void)buttonClick {
    ButtonClickCallback callBack = objc_getAssociatedObject(self, &overViewKey);
    if (callBack!= nil)
    {
        callBack(self);
    }
}

@end
