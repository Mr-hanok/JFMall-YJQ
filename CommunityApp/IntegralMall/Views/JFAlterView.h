//
//  JFAlterView.h
//  CommunityApp
//
//  Created by yuntai on 16/4/26.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFAlterView : UIView
@property (weak, nonatomic) IBOutlet UIView *alterview;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic,copy) void (^btnClickCallBack)(NSInteger tag);
- (void)configAlterViewWithmessage:(NSString *)message title:(NSString *)title;
@end
