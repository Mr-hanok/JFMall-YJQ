//
//  FKAlertView.m
//  AlertView
//
//  Created by Faker on 15/12/29.
//  Copyright © 2015年 Faker. All rights reserved.
//

#import "FKAlertView.h"
#import "RoadAddressManageViewController.h"

@interface FKAlertView ()


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *contnLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *otherButton;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, weak) NSString *otherStr;

@end

@implementation FKAlertView


- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel other:(NSString *)other
{
   
    self = [super initWithFrame:frame];
    if (self) {
        self.otherStr = other;
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.image = [UIImage imageNamed:@"123.jpg"];
        [self addSubview:self.imageView];
        
        if (![title isEqualToString:@""] || title.length > 0) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        }
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.text = message;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.messageLabel];
        
        
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.layer.cornerRadius = 6;
        self.cancelButton.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.000];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.cancelButton.tag = 1000;
        [self.cancelButton setTitle:cancel forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];
        [self.cancelButton addTarget:self action:@selector(clickCancen:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.otherButton.layer.cornerRadius = 6;
        self.otherButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.96 blue:0.21 alpha:1.000];
        [self.otherButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.otherButton.tag = 1001;
        [self.otherButton setTitle:other forState:UIControlStateNormal];
        [self addSubview:self.otherButton];
        [self.otherButton addTarget:self action:@selector(clickCancen:) forControlEvents:UIControlEventTouchUpInside];
        
    
    }
    return self;
}

- (void)layoutSubviews
{
//    self.imageView.frame = self.bounds.size;
    NSLog(@"+++++++++++++++++++++++%f",self.imageView.image.size.height);
    self.imageView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y  ,self.bounds.size.width, self.imageView.image.size.height*0.6);
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGSize messageSize = [self.messageLabel.text sizeWithFont:self.messageLabel.font];


//    self.imageView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y  ,self.bounds.size.width, 20+ titleSize.height+20+messageSize.height+20+80);
    float offsetW = self.imageView.frame.size.width;

        self.titleLabel.frame = CGRectMake(0, 20, offsetW, 30);

//    self.messageLabel.frame = CGRectMake(25, CGRectGetHeight(self.titleLabel.frame) + 20  ,offsetW - 45, 30);
//    [self.messageLabel sizeToFit];

    self.messageLabel.frame=  CGRectMake(30,CGRectGetHeight(self.titleLabel.frame) + 20 , offsetW - 60, messageSize.height+20);

    if (![self.otherStr isEqualToString:@""]) {
        self.otherButton.hidden = NO;

        self.cancelButton.frame = CGRectMake( offsetW /5-15, CGRectGetMaxY(self.messageLabel.frame) + 20 ,  80, 30);

    }else{
        self.otherButton.hidden = YES;
        self.cancelButton.frame = CGRectMake((offsetW - 80)/2, CGRectGetMaxY(self.messageLabel.frame) + 20 ,  80, 30);
    }
    
    
    self.otherButton.frame = CGRectMake( offsetW -130, CGRectGetMaxY(self.messageLabel.frame) + 20 ,  80, 30);
   
}

- (void)clickCancen:(UIButton *)sender
{
    if (sender.tag == 1000) {

        [self alertViewHidden];

    }else if (sender.tag == 1001)
    {
        if (self.lookBaojiaBlock) {
            self.lookBaojiaBlock();
        }
    }
}


- (void)alertViewHidden
{
    if (self.quxiaoBlock) {
        self.quxiaoBlock();
    }
    [self removeFromSuperview];
}

@end
