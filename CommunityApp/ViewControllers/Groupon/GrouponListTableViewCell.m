//
//  GrouponListTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/7/27.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponListTableViewCell.h"
#import "UIImageView+AFNetworking.h"

typedef enum{
    GpStateSelling = 1,     // 1:已开始
    GpStateDone,            // 2:已结束
    GpStateWill             // 3.未开始
}GrouponState;

@interface GrouponListTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *grouponBgView;
@property (weak, nonatomic) IBOutlet UIImageView *grouponPicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *grouponStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *grouponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *grouponDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *grouponTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *grouponAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *grouponBuyNowLabel;

@property (copy, nonatomic) NSString  *grouponState;

@property (nonatomic, copy) NSString  *groupBuyStartTime;
@property (nonatomic, copy) NSString  *groupBuyEndTime;

@property (nonatomic, assign) NSInteger     allSeconds;

@end

@implementation GrouponListTableViewCell

- (void)awakeFromNib {
    [self initBgViewStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)loadCellData:(GrouponList *)model {
    
    NSLog(@"-------loadCellData GrouponList %@--------", self);
    
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:model.goodsUrl]];
    [self.grouponPicImageView setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    [self.grouponNameLabel setText:model.goodsName];
    [self.grouponDetailLabel setText:model.groupBuyDetail];
    [self.grouponAmountLabel setText:[NSString stringWithFormat:@"￥%@ ",model.goodsActualPrice]];

    _groupBuyStartTime = model.groupBuyStartTime;
    _groupBuyEndTime = model.groupBuyEndTime;
    [self countGroupBuyTime];

//    NSArray *afterTimes = [model.residueEndTime componentsSeparatedByString:@","];
//    //NSLog(@"loadCellData:afterTimes:%@ timer:%@",afterTimes,_timer);
//
//    if (afterTimes.count == 4) {
//        NSString *strDays = [afterTimes objectAtIndex:0];
//        NSString *strHours = [afterTimes objectAtIndex:1];
//        NSString *strMinutes = [afterTimes objectAtIndex:2];
//        NSString *strSeconds = [afterTimes objectAtIndex:3];
//        [self.grouponTimerLabel setText:[NSString stringWithFormat:@"还剩%@天%@小时%@分%@秒", strDays, strHours, strMinutes, strSeconds]];
//        
//        NSInteger days = [strDays integerValue];
//        NSInteger hours = [strHours integerValue];
//        NSInteger minutes = [strMinutes integerValue];
//        NSInteger seconds = [strSeconds integerValue];
//        _allSeconds = 24*60*60*days + 60*60*hours + 60*minutes + seconds;
//        
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDispTime) userInfo:nil repeats:YES];
////        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
//
//    }
    
    self.grouponState = model.groupBuyState;
    [self setGrouponStateLabel];
}


- (void)countGroupBuyTime
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *strNow = [formatter stringFromDate:now];
    NSDate *startTime = [formatter dateFromString:_groupBuyStartTime];
    NSDate *endTime = [formatter dateFromString:_groupBuyEndTime];
    if ([now compare:endTime] == NSOrderedDescending) {
        [self.grouponTimerLabel setText:@"该团购已结束"];
        self.grouponState = @"2";
    }else if ([now compare:startTime] == NSOrderedAscending) {
        self.grouponState = @"3";
        if (_groupBuyStartTime.length == 19) {
            NSString *strNowYear = [strNow substringToIndex:4];
            NSString *strStartYear = [_groupBuyStartTime substringToIndex:4];
            NSInteger nowYear = [strNowYear integerValue];
            NSInteger startYear = [strStartYear integerValue];
            
            NSString *strNowMonth = [strNow substringWithRange:NSMakeRange(5, 2)];
            NSString *strStartMonth = [_groupBuyStartTime substringWithRange:NSMakeRange(5, 2)];
            NSInteger nowMonth = [strNowMonth integerValue];
            NSInteger startMonth = [strStartMonth integerValue];
            
            NSString *strStartDay = [_groupBuyStartTime substringWithRange:NSMakeRange(8, 2)];
            
            if (startYear > nowYear) {
                [self.grouponTimerLabel setText:[NSString stringWithFormat:@"%@年%@月开始", strStartYear, strStartMonth]];
            }else if (startMonth > nowMonth) {
                [self.grouponTimerLabel setText:[NSString stringWithFormat:@"%@月%@日开始", strStartMonth, strStartDay]];
            }else {
                NSTimeInterval timerInterval = [startTime timeIntervalSinceDate:now];
                NSInteger _diffDate = (NSInteger)timerInterval;
                NSInteger day = _diffDate / (60*60*24) ;
                NSInteger hour = (_diffDate - day*60*60*24) / (60*60);
                NSInteger minute = (_diffDate - day*60*60*24 - hour*60*60) / 60;
                NSInteger second = _diffDate - day*60*60*24 - hour*60*60 - minute*60;
                [self.grouponTimerLabel setText:[NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒后开始", (long)day, (long)hour, (long)minute, (long)second]];
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countGroupBuyTime) userInfo:nil repeats:NO];
            }
        }
    }else{
        self.grouponState = @"1";
        if (_groupBuyEndTime.length == 19) {
            NSString *strNowYear = [strNow substringToIndex:4];
            NSString *strEndYear = [_groupBuyEndTime substringToIndex:4];
            NSInteger nowYear = [strNowYear integerValue];
            NSInteger endYear = [strEndYear integerValue];
            
            NSString *strNowMonth = [strNow substringWithRange:NSMakeRange(5, 2)];
            NSString *strEndMonth = [_groupBuyEndTime substringWithRange:NSMakeRange(5, 2)];
            NSInteger nowMonth = [strNowMonth integerValue];
            NSInteger endMonth = [strEndMonth integerValue];
            NSString *strEndDay = [_groupBuyEndTime substringWithRange:NSMakeRange(8, 2)];
            
            if (endYear > nowYear) {
                [self.grouponTimerLabel setText:[NSString stringWithFormat:@"截止时间:%@年%@月", strEndYear, strEndMonth]];
            }else if (endMonth > nowMonth) {
                [self.grouponTimerLabel setText:[NSString stringWithFormat:@"截止时间:%@月%@日", strEndMonth, strEndDay]];
            }else {
                NSTimeInterval timerInterval = [endTime timeIntervalSinceDate:now];
                NSInteger _diffDate = (NSInteger)timerInterval;
                NSInteger day = _diffDate / (60*60*24) ;
                NSInteger hour = (_diffDate - day*60*60*24) / (60*60);
                NSInteger minute = (_diffDate - day*60*60*24 - hour*60*60) / 60;
                NSInteger second = _diffDate - day*60*60*24 - hour*60*60 - minute*60;
                [self.grouponTimerLabel setText:[NSString stringWithFormat:@"剩余%ld天%ld时%ld分%ld秒", (long)day, (long)hour, (long)minute, (long)second]];
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countGroupBuyTime) userInfo:nil repeats:NO];
            }
        }
    }
    
    [self setGrouponStateLabel];
}



// 更新倒计时时间
- (void)updateDispTime
{
    NSLog(@"%ld", (long)_allSeconds);
    _allSeconds--;
    if (_allSeconds > 0) {
        NSInteger days = _allSeconds / (24*60*60);
        NSInteger hours = (_allSeconds - days*24*60*60) / (60*60);
        NSInteger minutes = (_allSeconds - days*24*60*60 - hours*60*60) / 60;
        NSInteger seconds = _allSeconds - days*24*60*60 - hours*60*60 - minutes*60;
        [self.grouponTimerLabel setText:[NSString stringWithFormat:@"还剩%ld天%ld小时%ld分%ld秒", (long)days, (long)hours, (long)minutes, (long)seconds]];
    }else {
        if (self.clearTimer) {
            self.clearTimer(_timer);
        }
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)initBgViewStyle {
    [Common setRoundBorder:_grouponBgView borderWidth:0.5 cornerRadius:8 borderColor:Color_Gray_RGB];
    [Common setRoundBorder:_grouponBuyNowLabel borderWidth:0.5 cornerRadius:3 borderColor:Color_Orange_RGB];
}

- (void)setBuyNowLabelBorder:(CALayer *)layer {
    layer.borderWidth = 1;
    layer.cornerRadius = 3;
    layer.masksToBounds = YES;
    layer.borderColor = COLOR_RGB(246, 131, 29).CGColor;
    layer.backgroundColor =[UIColor whiteColor].CGColor;
}

- (IBAction)clickBuyNowBtn:(id)sender {
    if(self.dialBuyNowBlock){
        self.dialBuyNowBlock();
    }
}

- (void)isRemoveBuyNowBtn:(BOOL)isRemove {
    [_grouponBuyNowLabel setHidden:isRemove];
    
}

- (void)setGrouponStateLabel {
    BOOL isRemove = NO;
    switch (_grouponState.intValue) {
        case GpStateWill:
            [_grouponStateImageView setImage:[UIImage imageNamed:@"GrouponStateWill"]];
            isRemove = YES;
            break;
        case GpStateSelling:
            [_grouponStateImageView setImage:[UIImage imageNamed:@"GrouponStateSelling"]];
            break;
        case GpStateDone:
            [_grouponStateImageView setImage:[UIImage imageNamed:@"GrouponStateDone"]];
            [_grouponTimerLabel setText:@"该团购已结束"];
            isRemove = YES;
            break;
        default:
            break;
    }
    [self isRemoveBuyNowBtn:isRemove];
}

@end
