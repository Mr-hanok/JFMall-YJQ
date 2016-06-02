//
//  RefundViewController.m
//  CommunityApp
//
//  Created by issuser on 15/7/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "RefundViewController.h"

@interface RefundViewController ()

@property (weak, nonatomic) IBOutlet UIView *refundSnapshotView;
@property (weak, nonatomic) IBOutlet UIView *refundHistoryView;
@property (weak, nonatomic) IBOutlet UILabel *refundStatus;
@property (weak, nonatomic) IBOutlet UILabel *refundReason;
@property (weak, nonatomic) IBOutlet UILabel *refundQuantity;
@property (weak, nonatomic) IBOutlet UILabel *refundAmount;
@property (weak, nonatomic) IBOutlet UILabel *refundEvent;
@property (weak, nonatomic) IBOutlet UILabel *refundTime;

@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Near_Shop_Title;
    [self initWidgetStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化控件样式
- (void)initWidgetStyle {
    [self drawViewLayerBorder:_refundSnapshotView];
    [self drawViewLayerBorder:_refundHistoryView];
    
}

// 描画View边框
-(void)drawViewLayerBorder:(UIView *)view {
    CALayer *viewLayer = view.layer;
    viewLayer.borderWidth = 1;
    viewLayer.cornerRadius = 8;
    viewLayer.masksToBounds = YES;
    viewLayer.borderColor = [[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1] CGColor];
}

@end
