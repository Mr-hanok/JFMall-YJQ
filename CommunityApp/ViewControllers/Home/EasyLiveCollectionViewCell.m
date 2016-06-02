//
//  EasyLiveCollectionViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "EasyLiveCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface EasyLiveCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *storeCoverImg;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (weak, nonatomic) IBOutlet UIView *catagoryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeNameWidth;
@property (weak, nonatomic) IBOutlet UIImageView *splitLine;

@end

@implementation EasyLiveCollectionViewCell

- (void)awakeFromNib {
    [Common updateLayout:_splitLine where:NSLayoutAttributeHeight constant:0.5];
}


// 装载Cell数据
- (void)loadCellData
{
     _starView.isEdit = FALSE;
}

// 装载Cell数据
- (void)loadCellData:(SurroundBusinessModel *)model hideSplitLine:(BOOL)isHide
{
    _starView.isEdit = FALSE;
    _splitLine.hidden = isHide;
    
    if (model.businessPicUrl != nil && model.businessPicUrl.length > 0) {
        NSArray* imgsArray =  [model.businessPicUrl componentsSeparatedByString:@","];
        if(imgsArray != nil && imgsArray.count > 0)
        {
            NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:[imgsArray objectAtIndex:0]]];
            [self.storeCoverImg setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"BusinessDefaultImg"]];
        }
    }
    
    if ([model.isVerified isEqualToString:@"1"]) {
        _vipBtn.layer.borderColor = Color_Orange_RGB.CGColor;
        _vipBtn.layer.borderWidth = 0.5;
        _vipBtn.layer.cornerRadius = 4;
        [_vipBtn setHidden:NO];
    }else {
        [_vipBtn setHidden:YES];
    }
    
    // [model.businessName isEqualToString:@"1"]?[_vipBtn setHidden:YES]:[_vipBtn setHidden:YES];
    
    CGFloat width = [Common labelDemandWidthWithText:model.businessName font:[UIFont systemFontOfSize:15.0] size:CGSizeMake(Screen_Width-205, 21)];
    self.storeNameWidth.constant = width;
    [self.price setText:[NSString stringWithFormat:@"￥%@/人",model.perConsumption]];
    [self.storeName setText:model.businessName];
    [self.address setText:model.address];
    [self setDialToStoreBlock:^{
        NSString *dialTel = [NSString stringWithFormat:@"tel://%@", model.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialTel]];
    }];
    
    [self.distance setText:model.distance];
    
    [_starView setScore:(NSInteger)([model.score floatValue] + 0.5)/kNUMBER_OF_STAR withAnimation:NO];
    
    // 插入标签 
//    NSArray *strings = @[@"西餐", @"澳洲牛排", @"一品香锅", @"澳洲牛排", @"一品香锅"];
    if (model.label != nil && model.label.length > 0) {
        NSArray *strings = [model.label componentsSeparatedByString:@"|"];
        [self insertLabelForStrings:strings toView:self.catagoryView andMaxWidth:Screen_Width-207];
    }
}

// 为指定字符串数组添加标签 For吃喝玩乐列表
-(void)insertLabelForStrings:(NSArray *)strings toView:(UIView *)view andMaxWidth:(CGFloat)maxWidth
{
    CGFloat labelHeight = 20.0;                 // 标签高度
    CGFloat labelMargin = 6.0;                  // 标签之间的Margin
    CGFloat additionalWidth = 6.0;              // label附加宽度
    UIFont  *font = [UIFont systemFontOfSize:13.0];  // 字体大小
    
    [Common insertLabelForStrings:strings toView:view andViewHeight:27.0 andMaxWidth:maxWidth andLabelHeight:labelHeight andLabelMargin:labelMargin andAddtionalWidth:additionalWidth andFont:font andBorderColor:Color_Comm_LabelBorder andTextColor:COLOR_RGB(120, 120, 120)];
}

// 拨号按钮点击事件处理函数
- (IBAction)dialBtnClickHandler:(id)sender
{
    if (self.dialToStoreBlock) {
        self.dialToStoreBlock();
    }
}

@end
