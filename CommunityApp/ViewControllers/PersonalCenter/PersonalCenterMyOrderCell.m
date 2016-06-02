//
//  UITableViewCell+PersonCenterMeCell.m
//  CommunityApp
//
//  Created by iss on 6/4/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderCell.h"
@interface PersonalCenterMyOrderCell()
@property(strong,nonatomic)IBOutlet UILabel* service;//
@property(strong,nonatomic)IBOutlet UILabel* price;
@property(strong,nonatomic)IBOutlet UILabel* totalPrice;
@property(strong,nonatomic)IBOutlet UILabel* serviceLabel;
@property(strong,nonatomic)IBOutlet UIView* bg;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//交易日期
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//交易时间
@property(weak,nonatomic)IBOutlet UILabel*orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel*dealStatus;//交易状态
@end
@implementation   PersonalCenterMyOrderCell
-(void) setCommodityCell:(materialsModel *)data  totalPrice:(NSString*)total
{
    if(data == nil)
        return;
     materialsModel* material =  data;
    [_service setText:material.CommodityName];
   // [_timeLabel setText:material.CommodityState];
  //  [_dealStatus setTitle:material.CommodityState forState:UIControlStateNormal];
    NSString* num = material.CommodityNum;
    NSString* price = material.CommodityPrice;
    YjqLog(@"%@",material);
    if (total == nil || [total isEqualToString:@""]) {
        [_totalPrice setHidden:TRUE];
    }
    else
    {
        [_totalPrice setHidden:FALSE];
        [_totalPrice setText:[NSString stringWithFormat:@"%@:￥%@",Str_MyOrder_Total,total]];
    }
//    material.CommoditySpecialPrice=@"567";
    NSString*specialPrice=material.CommoditySpecialPrice;//商品特价价格
    if (material.CommoditySpecialPrice.length!=0) {
        NSString *title =[[NSString alloc] initWithString:[NSString stringWithFormat:@"￥%@ ￥%@ X%@",specialPrice,price,num]];
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:title];
        // range1 = NSMakeRange(0, [price length]+1);//通过NSRange来划分片段
        NSRange range1 = NSMakeRange([specialPrice length]+1, [title length]-[specialPrice length]-1);
        UIColor* color1 = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1 ];
        [string addAttribute:NSForegroundColorAttributeName value:color1 range:range1];//给不同的片段设置不同的颜色
        //设置原价文字划线范围
        NSRange range2 = NSMakeRange([specialPrice length]+2, [title length]-[specialPrice length]-3-num.length);
        [string addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range2];
        [string addAttribute:NSStrikethroughColorAttributeName value:color1 range:range1];
        [_price setAttributedText:string];
    }else{
        NSString *title =[[NSString alloc] initWithString:[NSString stringWithFormat:@"￥%@ X%@",price,num]];
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:title];
        // range1 = NSMakeRange(0, [price length]+1);//通过NSRange来划分片段
        NSRange range1 = NSMakeRange([price length]+1, [title length]-[price length]-1);
        UIColor* color1 = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1 ];
        [string addAttribute:NSForegroundColorAttributeName value:color1 range:range1];//给不同的片段设置不同的颜色
        [_price setAttributedText:string];

    }
    [_price setHidden:FALSE];
    [_serviceLabel setHidden:TRUE];
    
}
-(void) setServiceCell:(ServiceOrderModel *)serviceOrder
{
    ServiceOrderBaseModel* data = serviceOrder.orderBase;
    if(data == nil)
        return;
    NSString *title ;
    NSString* appoint;
    if([data.stateId isEqualToString:@"6"])// 订单状态ID（1未处理，2处理中，3已处理，4已关闭，5已拒单 ,6已取消,7已删除,8待单中）
    {
        [_service setText:data.materials];
    }
    else
    {
       // if ([data.type isEqualToString:@"2"])//预约
        {
            appoint = [data.appointmenTime substringToIndex:data.appointmenTime.length-3];//remove ss
            title = [NSString stringWithFormat:@"%@ %@",data.materials,appoint];
            
        }
//        else
//        {
//            
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//            NSDate* createDate = [formatter dateFromString:data.createDate];
//            NSDate* appintDate = [[NSDate alloc]initWithTimeInterval:30*60 sinceDate:createDate];
//            NSString* appointTemp = [formatter stringFromDate:appintDate];
//            appoint = [appointTemp substringToIndex:appointTemp.length-3];
//            title = [NSString stringWithFormat:@"%@   %@",data.serviceName,appoint];
//        }
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:title];
        NSRange range1;
        // range1 = NSMakeRange(0, [price length]+1);//通过NSRange来划分片段
        range1 = NSMakeRange([title length]-[appoint length],[appoint length]);
        UIColor* color1 = COLOR_RGB(0, 0, 0);
        [string addAttribute:NSForegroundColorAttributeName value:color1 range:range1];//给不同的片段设置不同的颜色
        [_service setAttributedText:string];

    }
    

    if([serviceOrder.payInfo.payment isEqualToString:@"1"])//后付费
    {
        [_serviceLabel setHidden:FALSE];
        [_totalPrice setHidden:TRUE];
    }
    else
    {
        [_serviceLabel setHidden:TRUE];
        [_totalPrice setHidden:FALSE];
        CGFloat money = [serviceOrder.payInfo.money floatValue];
        [_price setText:[NSString stringWithFormat:@"￥%.2f", money]];
        [_totalPrice setText:[NSString stringWithFormat:@"%@:￥%.2f",Str_MyOrder_Total,money]];
    }
}

- (void)awakeFromNib {
    
    _serviceLabel.layer.borderWidth = 1.0;
    _serviceLabel.layer.borderColor = COLOR_RGB(57, 57, 57).CGColor;
    _serviceLabel.layer.cornerRadius = 1.0;

}
 
@end
