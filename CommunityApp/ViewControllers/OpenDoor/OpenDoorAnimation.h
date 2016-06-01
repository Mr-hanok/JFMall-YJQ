//
//  openDoorAnimation.h
//  CommunityApp
//
//  Created by lsy on 15/11/5.
//  Copyright © 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenDoorAnimation : UIWindow
//开门时间
//@property(nonatomic,copy)NSString*openDoortimeStr;
//单利
+(instancetype)share;
//显示动画
+(instancetype)showOpenDoorAnimation:(NSString*)openTimeString andSuccessOrFail:(int)signNum;
//显示弹窗
+(instancetype)showGiveToken;
@end
