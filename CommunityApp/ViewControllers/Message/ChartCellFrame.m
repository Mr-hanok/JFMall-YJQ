//
//  ChartCellFrame.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kIconMarginX 5
#define kIconMarginY 5
#define SysMessageDefaultHeight 311
#import "ChartCellFrame.h"

@implementation ChartCellFrame

-(void)setChartMessage:(ChartMessage *)chartMessage
{
    _chartMessage=chartMessage;
    
    CGSize winSize=[UIScreen mainScreen].bounds.size;
    CGFloat iconX=kIconMarginX;
    CGFloat iconY=kIconMarginY;
    CGFloat iconWidth=40;
    CGFloat iconHeight=40;
    
    if(chartMessage.messageType==kMessageFrom){
      
    }else if (chartMessage.messageType==kMessageTo){
        iconX=winSize.width-kIconMarginX-iconWidth;
    }
    else if(chartMessage.messageType==kMessageSys)
    {
        self.cellHeight = SysMessageDefaultHeight;
        CGFloat descHeight = [Common labelDemandHeightWithText:_chartMessage.content font:[UIFont systemFontOfSize:15]  size:CGSizeMake(Screen_Width-30, 50)];
        if(descHeight>20)
            self.cellHeight += descHeight-20;
        return;
    }
    self.iconRect=CGRectMake(iconX, iconY, iconWidth, iconHeight);
    
    CGFloat contentX=CGRectGetMaxX(self.iconRect)+kIconMarginX;
    CGFloat contentY=iconY;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 15]};
    CGSize contentSize=[chartMessage.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;

    if(chartMessage.messageType==kMessageTo){
    
        contentX=iconX-kIconMarginX-contentSize.width-iconWidth;
    }
    
    self.chartViewRect=CGRectMake(contentX, contentY, contentSize.width+35, contentSize.height+30);
    
    self.cellHeight=MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.chartViewRect))+kIconMarginX;
}
@end
