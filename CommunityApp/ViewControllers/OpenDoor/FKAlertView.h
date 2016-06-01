//
//  FKAlertView.h
//  AlertView
//
//  Created by Faker on 15/12/29.
//  Copyright © 2015年 Faker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKAlertView : UIView
@property(nonatomic, strong) void (^lookBaojiaBlock)();
@property(nonatomic, strong) void (^quxiaoBlock)();
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title  message:(NSString *)message cancel:(NSString *)cancel other:(NSString *)other;


- (void)alertViewHidden;

@end
