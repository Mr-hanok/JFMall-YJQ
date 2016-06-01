//
//  Common.h
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareHelper : NSObject

+(void)shareWithTitle:(NSString *)title text:(NSString *)text imageUrl:(NSString *)imageUrl resentedController:(UIViewController *)presentedController;

@end
