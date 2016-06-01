//
//  JFAlterView.m
//  CommunityApp
//
//  Created by yuntai on 16/4/26.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFAlterView.h"

@implementation JFAlterView

- (instancetype)init
{
    self = [super init];
    if (self) {
            }
    return self;
}
-(void)awakeFromNib{
    self.alterview.layer.cornerRadius = 5.f;
    self.alterview.layer.masksToBounds = YES;
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.titleLabel.textColor = HEXCOLOR(0x434751);
    self.messageLabel.textColor = HEXCOLOR(0x434751);

}
- (IBAction)btnClick:(UIButton *)sender {
    if (_btnClickCallBack) {
        self.btnClickCallBack(sender.tag);
    }
}
- (void)configAlterViewWithmessage:(NSString *)message title:(NSString *)title{
    self.messageLabel.text = message;
    self.titleLabel.text = title;
}
@end
