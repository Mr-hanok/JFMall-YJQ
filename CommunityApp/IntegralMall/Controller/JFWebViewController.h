//
//  JFWebViewController.h
//  CommunityApp
//
//  Created by yuntai on 16/5/26.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFBaseViewController.h"
#import "JFBannerModel.h"
/**webview点击轮播图跳转 小游戏等*/
@interface JFWebViewController : JFBaseViewController
@property (nonatomic, strong) JFBannerModel *bannerModel;
@end
