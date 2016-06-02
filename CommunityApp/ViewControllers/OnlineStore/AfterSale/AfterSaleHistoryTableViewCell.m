//
//  AfterSaleHistoryTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/7/24.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AfterSaleHistoryTableViewCell.h"

@interface AfterSaleHistoryTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView3;


@property (weak,nonatomic)IBOutlet UILabel* operationName;
@property (weak,nonatomic)IBOutlet UILabel* operationTime;
@property (weak,nonatomic)IBOutlet UILabel* content;
@property (weak,nonatomic)IBOutlet NSLayoutConstraint* contentHeight;
@property (weak,nonatomic)IBOutlet NSLayoutConstraint* bgViewHeight;
@property (weak,nonatomic)IBOutlet NSLayoutConstraint* footerViewHeight;
@property (weak,nonatomic)IBOutlet UIView* bgView;
@end

@implementation AfterSaleHistoryTableViewCell

- (void)awakeFromNib {
    _content.numberOfLines = 0;
    _content.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
-(void)loadCellData:(AfterSaleDealRecordDetail *)cellData
{
    if (cellData.attachment == nil || [cellData.attachment isEqualToString:@""]) {
        [_footerView setHidden:TRUE];
        _footerViewHeight.constant = 0.0f;
    }else
    {
        [_footerView setHidden:FALSE];
        _footerViewHeight.constant = FOOTVIEWHEIGHT;
    }
    [_operationName setText:cellData.operationName];
    [_operationTime setText:cellData.operationTime];
    [_content setText:cellData.content];
    CGFloat contectHeight = [Common labelDemandHeightWithText:_content.text font:_content.font size:CGSizeMake(_content.bounds.size.width, MAXFLOAT)];
    _contentHeight.constant = contectHeight;
    _bgViewHeight.constant = BGVIEWHEIGHT + (_footerViewHeight.constant - FOOTVIEWHEIGHT) + (_contentHeight.constant- CONTENTVIEWHEIGHT);
    _bgView.layer.borderColor = COLOR_RGB(220, 220, 220).CGColor;
    _bgView.layer.borderWidth = 0.5;
   // _bgView.layer.cornerRadius = 5.0;
}
@end
