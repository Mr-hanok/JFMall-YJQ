//
//  ComErrorViewManager.m
//  CommonApp
//
//  Created by lipeng on 16/4/8.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComErrorViewManager.h"

#define TDD_ERRORVIEW_WIDTH         250
#define TDD_ERRORVIEW_HEIGHT        250

@implementation ComErrorViewManager

+ (UILabel *)initErrorViewInView:(UIView *)view {
    [[view viewWithTag:198402] removeFromSuperview];
    CGFloat height = view.height > TDD_ERRORVIEW_HEIGHT ? view.height : APP_SCREEN_HEIGHT-20;
    UILabel *errorView = [[UILabel alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH-TDD_ERRORVIEW_WIDTH)/2,(height-TDD_ERRORVIEW_HEIGHT)/2, TDD_ERRORVIEW_WIDTH, TDD_ERRORVIEW_HEIGHT)];
    errorView.tag = 198402;
//    errorView.textAlign = kCTTextAlignmentCenter;
//    errorView.textColor = HEXCOLOR(0xbababf);
//    errorView.lineSpace = 5.f;
    [view addSubview:errorView];
    return errorView;
}

+ (UIView*)showErrorViewInView:(UIView*)view withError:(NSError*)error {
    UILabel *errorView = [[self class] initErrorViewInView:view];
//    errorView.imageDic = @{
//                           @"otherError":[UIImage iconWithInfo:TDDIconFontErrorOther],
//                           @"noNetwork":[UIImage iconWithInfo:TDDIconFontErrorNoNetWork],
//                           };
    
    NSString *errorMsg = error.domain;
    errorView.text = @"报错啦~~~";
    
//    if ([errorMsg isEqualToString:@"无网络"]) {
//        errorView.text = @"<img src='noNetwork' width='96' height='96' />\n<b fontSize='18'>没有网络连接</b>\n<b fontSize='14'>请检查网络设置是否完好</b>";
//    }
//    else {
//        errorView.text = [NSString stringWithFormat:@"<img src='otherError' width='96' height='96' />\n<b fontSize='18'>%@</b>", errorMsg];
//    }
    return errorView;
}

+ (void)removeErrorViewFromView:(UIView*)view  {
    [[view viewWithTag:198402] removeFromSuperview];
}

+ (UIView*)showEmptyViewInView:(UIView*)view {
    UILabel *errorView = [[self class] initErrorViewInView:view];
//    errorView.imageDic = @{@"errorImage":[UIImage iconWithInfo:TDDIconFontErrorNoData]};
//    errorView.text = @"<img src='errorImage' width='96' height='96' />\n<b fontSize='18'>当前没有数据</b>\n<b fontSize='14'>下拉刷新后再看看吧</b>";
    errorView.text = @"空的啊~~~";
    
    return errorView;
}

+ (UIView*)showErrorString:(NSString*)string inView:(UIView*)view {
    UILabel *errorView = [[self class] initErrorViewInView:view];
    errorView.font = [UIFont systemFontOfSize:18.f];
    errorView.text = string;
    return errorView;
}

@end
