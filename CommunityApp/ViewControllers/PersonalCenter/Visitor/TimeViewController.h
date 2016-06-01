//
//  TimeViewController.h
//  CommunityApp
//
//  Created by 张艳清 on 15/10/25.
//  Copyright © 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol backTimer<NSObject>
//下
@end
typedef void(^SelectTimeBlock)(NSString *str);
@interface TimeViewController : UIViewController
/**
 判断选择类型
 */
@property (nonatomic, strong) NSString *selectType;
@property (nonatomic, copy) SelectTimeBlock selectTime;
//上
@property(nonatomic,assign)id<backTimer>delegate;
@end
