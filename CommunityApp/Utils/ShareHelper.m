//
//  Common.h
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ShareHelper.h"

#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialWechatHandler.h"

@implementation ShareHelper

+(void)shareWithTitle:(NSString *)title text:(NSString *)text imageUrl:(NSString *)imageUrl resentedController:(UIViewController *)presentedController {
    [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = imageUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = text;
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:nil image:nil location:nil urlResource:nil presentedController:presentedController completion:nil];
    
//    [UMSocialSnsService presentSnsIconSheetView:presentedController
//                                         appKey:kUMengAppKey
//                                      shareText:nil
//                                     shareImage:nil
//                                shareToSnsNames:@[UMShareToWechatSession]
//                                       delegate:nil];
    
}

@end
