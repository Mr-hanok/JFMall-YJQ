//
//  GroupBuyCollectionViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GroupBuyCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface GroupBuyCollectionViewCell()
@property (nonatomic, retain) IBOutlet UIView *borderView;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *days;
@property (nonatomic, retain) IBOutlet UIButton *hour;
@property (nonatomic, retain) IBOutlet UIButton *minute;
@property (nonatomic, retain) IBOutlet UIButton *second;
@property (nonatomic, retain) IBOutlet UIImageView *picture;
@property (nonatomic, assign) NSTimeInterval timeDiff;
@property (nonatomic, retain) NSTimer   *updateTimer;

@end

@implementation GroupBuyCollectionViewCell

- (void)awakeFromNib {
   NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
   [notification  addObserver:self selector:@selector(clearTimer) name:ClearTimerNotification object:nil];
}


// 暂定团购封面用接口
- (void)loadCellDataForGroupon:(GrouponList *)wares
{
    [self.name setText:wares.goodsName];
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:wares.goodsUrl]];
    [self.picture setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
}


- (void)loadCellData:(WaresList *)wares
{
    [self.name setText:wares.goodsName];
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:wares.goodsUrl]];
    [self.picture setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *endDate = [formatter dateFromString:wares.limitEndTime];
    [self displayTime:endDate];
    [self.updateTimer invalidate];
    if (endDate != nil) {
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime:) userInfo:endDate repeats:YES];
    }
}

// 刷新时间
- (void)refreshTime:(NSTimer *)timer
{
    NSLog(@"refreshTime--%@", timer);
    NSDate *endDate = (NSDate *)timer.userInfo;
    [self displayTime:endDate];
    if (_timeDiff == 0) {
        [timer invalidate];
        if (self.groupBuyTimeOutBlock) {
            self.groupBuyTimeOutBlock();
        }
    }
}

// 显示时间
- (void)displayTime:(NSDate *)endDate
{
     _timeDiff = [endDate timeIntervalSinceNow];
    NSInteger day = _timeDiff/86400;   // 86400=24*60*60
    NSInteger hour = (_timeDiff-(86400*day))/3600;   // 3600=60*60
    NSInteger minute = (_timeDiff-(86400*day)-hour*3600)/60;
    NSInteger second = _timeDiff-86400*day-hour*3600-minute*60;
    
    [self.days setText:[NSString stringWithFormat:@"%ld天",(long)day]];
    
    if (hour >= 10) {
        [self.hour setTitle:[NSString stringWithFormat:@"%ld",(long)hour] forState:UIControlStateNormal];
    }else {
        [self.hour setTitle:[NSString stringWithFormat:@"0%ld",(long)hour] forState:UIControlStateNormal];
    }
    
    if (minute >= 10) {
        [self.minute setTitle:[NSString stringWithFormat:@"%ld",(long)minute]  forState:UIControlStateNormal];
    }else {
        [self.minute setTitle:[NSString stringWithFormat:@"0%ld",(long)minute]  forState:UIControlStateNormal];
    }
    
    if (second >= 10) {
        [self.second setTitle:[NSString stringWithFormat:@"%ld",(long)second]  forState:UIControlStateNormal];
    }else {
        [self.second setTitle:[NSString stringWithFormat:@"0%ld",(long)second]  forState:UIControlStateNormal];
    }

    [self reloadInputViews];
}


#pragma mark - 清Timer函数
- (void)clearTimer
{
    NSLog(@"clearTimer");
    [self.updateTimer invalidate];
}

@end
