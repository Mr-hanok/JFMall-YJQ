//
//  LimitBuyCollectionViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "LimitBuyCollectionViewCell.h"
#import "UIButton+AFNetworking.h"

@interface LimitBuyCollectionViewCell()

//@property (nonatomic, assign) NSInteger     diffDate;

@property (nonatomic, copy) NSString *limitStartTime;
@property (nonatomic, copy) NSString *limitEndTime;

@end

@implementation LimitBuyCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - 加载Cell数据
- (void)loadCellData:(WaresList *)wares
{
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:wares.goodsUrl]];
    [_goodsImgBtn setBackgroundImageForState:UIControlStateNormal withURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    
    [_goodsName setText:wares.goodsName];
#pragma -mark 限时抢商品列表价格显示销售价格
    [_goodsPrice setText:wares.goodsPrice];
    
    _limitStartTime = wares.limitStartTime;
    _limitEndTime = wares.limitEndTime;

    [self countLimitBuyTime];
    
//    NSDate *now = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString *strNow = [formatter stringFromDate:now];
//    if(_timer)
//        [_timer invalidate];//cell复用时清除遗留数据
//    _timer =nil;
//    NSDate *startTime = [formatter dateFromString:wares.limitStartTime];
//    NSDate *endTime = [formatter dateFromString:wares.limitEndTime];
//    if ([now compare:endTime] == NSOrderedDescending) {
//        [self.goodsTimer setText:@"已结束"];
//    }else if ([now compare:startTime] == NSOrderedAscending) {
//        [self.goodsTimer setText:@"未开始"];
//    }else{
//        if (strNow.length > 18 && wares.limitEndTime.length > 18) {
//            NSString *strNowYear = [strNow substringToIndex:4];
//            NSString *strEndYear = [wares.limitEndTime substringToIndex:4];
//            NSInteger nowYear = [strNowYear integerValue];
//            NSInteger endYear = [strEndYear integerValue];
//            
//            NSString *strNowMonth = [strNow substringWithRange:NSMakeRange(5, 2)];
//            NSString *strEndMonth = [wares.limitEndTime substringWithRange:NSMakeRange(5, 2)];
//            NSInteger nowMonth = [strNowMonth integerValue];
//            NSInteger endMonth = [strEndMonth integerValue];
//            
//            if (endYear > nowYear) {
//                [self.goodsTimer setText:[NSString stringWithFormat:@"%@年", strEndYear]];
//            }else if (endMonth > nowMonth) {
//                [self.goodsTimer setText:[NSString stringWithFormat:@"%@月", strEndMonth]];
//            }else {
//                NSTimeInterval timerInterval = [endTime timeIntervalSinceDate:now];
//                _diffDate = (NSInteger)timerInterval;
//                NSInteger day = _diffDate / (60*60*24) ;
//                NSInteger hour = (_diffDate - day*60*60*24) / (60*60);
//                NSInteger minute = (_diffDate - day*60*60*24 - hour*60*60) / 60;
//                NSInteger second = _diffDate - day*60*60*24 - hour*60*60 - minute*60;
//                [self.goodsTimer setText:[NSString stringWithFormat:@"剩余%ld天%ld时%ld分%ld秒", (long)day, (long)hour, (long)minute, (long)second]];
//                
//                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDispTime) userInfo:nil repeats:YES];
//            }
//        }
//    }
}


- (void)countLimitBuyTime
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_limitStartTime == nil || _limitStartTime.length <= 0 || _limitEndTime == nil || _limitEndTime.length <= 0) {
        [self.goodsTimer setText:@"已结束"];
        return;
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *strNow = [formatter stringFromDate:now];
    NSDate *startTime = [formatter dateFromString:_limitStartTime];
    NSDate *endTime = [formatter dateFromString:_limitEndTime];
    if ([now compare:endTime] == NSOrderedDescending) {
        [self.goodsTimer setText:@"已结束"];
    }else if ([now compare:startTime] == NSOrderedAscending) {
        if (_limitStartTime.length == 19) {
            NSString *strNowYear = [strNow substringToIndex:4];
            NSString *strStartYear = [_limitStartTime substringToIndex:4];
            NSInteger nowYear = [strNowYear integerValue];
            NSInteger startYear = [strStartYear integerValue];
            
            NSString *strNowMonth = [strNow substringWithRange:NSMakeRange(5, 2)];
            NSString *strStartMonth = [_limitStartTime substringWithRange:NSMakeRange(5, 2)];
            NSInteger nowMonth = [strNowMonth integerValue];
            NSInteger startMonth = [strStartMonth integerValue];
            
            NSString *strStartDay = [_limitStartTime substringWithRange:NSMakeRange(8, 2)];
            
            if (startYear > nowYear) {
                [self.goodsTimer setText:[NSString stringWithFormat:@"%@年%@月开始", strStartYear, strStartMonth]];
            }else if (startMonth > nowMonth) {
                [self.goodsTimer setText:[NSString stringWithFormat:@"%@月%@日开始", strStartMonth, strStartDay]];
            }else {
                NSTimeInterval timerInterval = [startTime timeIntervalSinceDate:now];
                NSInteger _diffDate = (NSInteger)timerInterval;
                NSInteger day = _diffDate / (60*60*24) ;
                NSInteger hour = (_diffDate - day*60*60*24) / (60*60);
                NSInteger minute = (_diffDate - day*60*60*24 - hour*60*60) / 60;
                NSInteger second = _diffDate - day*60*60*24 - hour*60*60 - minute*60;
                [self.goodsTimer setText:[NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒后开始", (long)day, (long)hour, (long)minute, (long)second]];
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countLimitBuyTime) userInfo:nil repeats:NO];
            }
        }
    }else{
        if (_limitEndTime.length == 19) {
            NSString *strNowYear = [strNow substringToIndex:4];
            NSString *strEndYear = [_limitEndTime substringToIndex:4];
            NSInteger nowYear = [strNowYear integerValue];
            NSInteger endYear = [strEndYear integerValue];
            
            NSString *strNowMonth = [strNow substringWithRange:NSMakeRange(5, 2)];
            NSString *strEndMonth = [_limitEndTime substringWithRange:NSMakeRange(5, 2)];
            NSInteger nowMonth = [strNowMonth integerValue];
            NSInteger endMonth = [strEndMonth integerValue];
            NSString *strEndDay = [_limitEndTime substringWithRange:NSMakeRange(8, 2)];
            
            if (endYear > nowYear) {
                [self.goodsTimer setText:[NSString stringWithFormat:@"截止时间:%@年%@月", strEndYear, strEndMonth]];
            }else if (endMonth > nowMonth) {
                [self.goodsTimer setText:[NSString stringWithFormat:@"截止时间:%@月%@日", strEndMonth, strEndDay]];
            }else {
                NSTimeInterval timerInterval = [endTime timeIntervalSinceDate:now];
                NSInteger _diffDate = (NSInteger)timerInterval;
                NSInteger day = _diffDate / (60*60*24) ;
                NSInteger hour = (_diffDate - day*60*60*24) / (60*60);
                NSInteger minute = (_diffDate - day*60*60*24 - hour*60*60) / 60;
                NSInteger second = _diffDate - day*60*60*24 - hour*60*60 - minute*60;
                [self.goodsTimer setText:[NSString stringWithFormat:@"剩余%ld天%ld时%ld分%ld秒", (long)day, (long)hour, (long)minute, (long)second]];
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countLimitBuyTime) userInfo:nil repeats:NO];
            }
        }
    }
}



//#pragma mark - 更新倒计时时间
//- (void)updateDispTime
//{
//    _diffDate--;
//    if (_diffDate > 0) {
//        NSInteger day = _diffDate / (60*60*24) ;
//        NSInteger hour = (_diffDate - day*60*60*24) / (60*60);
//        NSInteger minute = (_diffDate - day*60*60*24 - hour*60*60) / 60;
//        NSInteger second = _diffDate - day*60*60*24 - hour*60*60 - minute*60;
//        [self.goodsTimer setText:[NSString stringWithFormat:@"剩余%ld天%ld时%ld分%ld秒", (long)day, (long)hour, (long)minute, (long)second]];
//    }else {
//        [self.goodsTimer setText:@"已结束"];
//        if (self.clearTimer) {
//            self.clearTimer(_timer);
//        }
//        [_timer invalidate];
//        _timer = nil;
//    }
//}



#pragma mark - 购物车按钮点击事件处理函数
- (IBAction)cartBtnClickHandler:(id)sender
{
    if (self.cartBtnClickBlock) {
        self.cartBtnClickBlock();
    }
}


@end
