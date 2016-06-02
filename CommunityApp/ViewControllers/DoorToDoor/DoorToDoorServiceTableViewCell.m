//
//  DoorToDoorServiceTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "DoorToDoorServiceTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface DoorToDoorServiceTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;

@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@end

@implementation DoorToDoorServiceTableViewCell

- (void)awakeFromNib {
    //添加图片
//    NSURL *url = [NSURL URLWithString:[Common setCorrectURL:nil]];
//    [_serviceImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    [self initUIViewStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -- 初始化样式
- (void)initUIViewStyle {
    _heightConstraint.constant = Screen_Width * (2.0 / 5.0);
    [self initLabelViewStyle:_labelView];
}

- (void)initLabelViewStyle:(UIView *)view {
    // 标签颜色计数器
    static NSInteger labelCount = 0;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    switch (labelCount % 3) {
        case 0:
            {
                [view setBackgroundColor:Color_Blue_RGB];
            }
            break;
        case 1:
            {
                [view setBackgroundColor:Color_Orange_RGB];
            }
            break;
        case 2:
            {
                [view setBackgroundColor:Color_Pink_Red_RGB];
            }
            break;
        default:
            break;
    }
    labelCount ++;
}

- (void)loadCellData:(ServiceList *)model {
    
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:model.serviceLogoUrl]];
    [self.serviceImageView setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"HouseKeepSildeDefaultImg"]];
    [self.serviceNameLabel setText:model.serviceName];
}
@end
