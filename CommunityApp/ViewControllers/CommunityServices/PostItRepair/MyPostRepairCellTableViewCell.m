//
//  CSPRMyPostRepairCellTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "MyPostRepairCellTableViewCell.h"
#import "MyPostRepairFollowViewController.h"

@interface MyPostRepairCellTableViewCell()

@end

@implementation MyPostRepairCellTableViewCell


- (void)awakeFromNib
{
    self.layer.borderColor = COLOR_RGB(220, 220, 220).CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 3.0;
//    /////////新加
//    self.dealButton.userInteractionEnabled=NO;
//    self.dealButton.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

/**
 * 跳转到处理进度
 */
-(void)addTrackTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.dealButton addTarget:target action:action forControlEvents:controlEvents];
}

/**
 * 完成页面跳转到我的处理进度
 */
-(void)addDelProgressButtonOfComplatePageTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.delProgressButtonOfComplatePage addTarget:target action:action forControlEvents:controlEvents];
}

-(void)addCancelTrackTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.cancelButton addTarget:target action:action forControlEvents:controlEvents];
}

/**
 * 加载数据
 */
-(void) loadCellData:(MyPostRepair *)myPostRepair
{
    [self.dateLabel setText:[myPostRepair.createDate substringToIndex:myPostRepair.createDate.length-3]];//remove ss
    [self.orderLabel setText:[NSString stringWithFormat:@"NO.%@",myPostRepair.orderNum]];
    [self.delStatusLabel setText:myPostRepair.state];
    [self.serviceNameLabel setText:myPostRepair.serviceName];
}


@end
