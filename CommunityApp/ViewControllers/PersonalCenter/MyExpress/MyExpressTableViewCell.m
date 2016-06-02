//
//  MyExpressTableViewCell.m
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/21.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "MyExpressTableViewCell.h"

@implementation MyExpressTableViewCell

- (void)awakeFromNib {
    [Common setRoundBorder:_borderView borderWidth:0.5 cornerRadius:3 borderColor:Color_Gray_RGB];
    
    _leftBtn.layer.borderColor = Color_Gray_RGB.CGColor;
    _leftBtn.layer.borderWidth = 0.5;
    _leftBtn.layer.cornerRadius = 3;
    
    _orderTrackBtn.layer.borderColor = Color_Gray_RGB.CGColor;
    _orderTrackBtn.layer.borderWidth = 0.5;
    _orderTrackBtn.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 加载Cell数据
- (void)LoadCellData:(ExpressOrderModel *)model
{
    if (model.createDate) {
        [_timeLabel setText:model.createDate];
    }
    
    [self setOrderStatus:model.stateId];
    
    NSString *expressInfo = @"";
    if (model.expressName) {
        expressInfo = [expressInfo stringByAppendingString:model.expressName];
    }
    
    if (model.expressNo) {
        expressInfo = [expressInfo stringByAppendingString:model.expressNo];
    }
    [_expressInfoLabel setText:expressInfo];
    
    if (model.stateId != nil && [model.stateId isEqualToString:@"2"]) {
        [_leftBtn setHidden:NO];
        [_leftBtn setTitle:@"查询快递" forState:UIControlStateNormal];
        [_leftBtn setTitle:@"查询快递" forState:UIControlStateHighlighted];
    }else if (model.stateId != nil && [model.stateId isEqualToString:@"1"]) {
        [_leftBtn setHidden:NO];
        [_leftBtn setTitle:@"二维码" forState:UIControlStateNormal];
        [_leftBtn setTitle:@"二维码" forState:UIControlStateHighlighted];
    }else {
        [_leftBtn setHidden:YES];
    }
}

// 设置订单状态
- (void)setOrderStatus:(NSString *)stateId
{
    if (stateId) {
        NSString *status = @"";
        _statusId = [stateId integerValue];
        switch (_statusId) {
            case 0:
                status = @"待寄件";
                break;
            
            case 1:
                status = @"待取件";
                break;
                
            case 2:
                status = @"已寄件";
                break;
            
            case 3:
                status = @"已取件";
                break;
                
            case 4:
                status = @"已取消";
                break;
                
            case 5:
                status = @"已完成";
                break;
                
            default:
                break;
        }
        
        [_statusLabel setText:status];
    }
}



#pragma mark - 订单跟踪按钮点击事件处理函数
- (IBAction)orderTrackBtnClickHandler:(id)sender
{
    if (_orderTrackBlock) {
        _orderTrackBlock();
    }
}


#pragma mark - 二维码 / 快递查询 按钮点击事件处理函数
- (IBAction)leftBtnClickHandler:(id)sender
{
    if (_statusId == 1) {
        if (_barcodeBlock) {
            _barcodeBlock();
        }
    }

    if (_statusId == 2) {
        if (_expressSearchBlock) {
            _expressSearchBlock();
        }
    }

}


@end
