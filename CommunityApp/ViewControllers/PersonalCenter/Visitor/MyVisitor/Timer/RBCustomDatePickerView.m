//
//  RBCustomDatePickerView.m
//  RBCustomDateTimePicker
//  e-mail:rbyyy924805@163.com
//  Created by renbing on 3/17/14.
//  Copyright (c) 2014 renbing. All rights reserved.
//

#import "RBCustomDatePickerView.h"
//颜色和透明度设置
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface RBCustomDatePickerView()
{
    UIView                      *timeBroadcastView;//定时播放显示视图
    MXSCycleScrollView          *yearScrollView;//年份滚动视图
    MXSCycleScrollView          *monthScrollView;//月份滚动视图
    MXSCycleScrollView          *dayScrollView;//日滚动视图
    MXSCycleScrollView          *hourScrollView;//时滚动视图
    MXSCycleScrollView          *minuteScrollView;//分滚动视图
//    MXSCycleScrollView          *secondScrollView;//秒滚动视图
    UILabel                     *nowPickerShowTimeLabel;//当前picker显示的时间
    UILabel                     *selectTimeIsNotLegalLabel;//所选时间是否合法
    UIButton                    *OkBtn;//自定义picker上的确认按钮
}
@end

@implementation RBCustomDatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTimeBroadcastView];
    }
    return self;
}
//-(void)setCurrentTime:(NSString *)currentTime
//{
//    //获取当前系统时间
//    NSDate *  senddate=[NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSString *  currentTimeString=[dateformatter stringFromDate:senddate];
//    currentTime=currentTimeString;
//}
#pragma mark -custompicker
//设置自定义datepicker界面
- (void)setTimeBroadcastView
{
    nowPickerShowTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-278.5/2, 117.0, 278.5, 18)];
    [nowPickerShowTimeLabel setBackgroundColor:[UIColor clearColor]];
    [nowPickerShowTimeLabel setFont:[UIFont systemFontOfSize:18.0]];
    [nowPickerShowTimeLabel setTextColor:RGBA(51, 51, 51, 1)];
    [nowPickerShowTimeLabel setTextAlignment:NSTextAlignmentCenter];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    //  NSString *weekString = [self fromDateToWeek:dateString];
    NSInteger monthInt = [dateString substringWithRange:NSMakeRange(4, 2)].integerValue;
    NSInteger dayInt = [dateString substringWithRange:NSMakeRange(6, 2)].integerValue;

    nowPickerShowTimeLabel.text = [NSString stringWithFormat:@"%@-%ld-%ld %@:%@",[dateString substringWithRange:NSMakeRange(0, 4)],(long)monthInt,(long)dayInt,[dateString substringWithRange:NSMakeRange(8, 2)],[dateString substringWithRange:NSMakeRange(10, 2)]/*,[dateString substringWithRange:NSMakeRange(12, 2)]*/];
    self.timeStr = nowPickerShowTimeLabel.text;
    NSLog(@"%@",self.timeStr);
    [self addSubview:nowPickerShowTimeLabel];

    timeBroadcastView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-278.5/2, 140, 278.5, 190.0)];
    timeBroadcastView.layer.cornerRadius = 8;//设置视图圆角
    timeBroadcastView.layer.masksToBounds = YES;
    CGColorRef cgColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    timeBroadcastView.layer.borderColor = cgColor;
    timeBroadcastView.layer.borderWidth = 2.0;
    [self addSubview:timeBroadcastView];
    UIView *beforeSepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 278.5, 1.5)];
    [beforeSepLine setBackgroundColor:RGBA(237.0, 237.0, 237.0, 1.0)];
    [timeBroadcastView addSubview:beforeSepLine];
    UIView *middleSepView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, 278.5, 38)];
    [middleSepView setBackgroundColor:RGBA(249.0, 138.0, 20.0, 1.0)];
    [timeBroadcastView addSubview:middleSepView];
    UIView *bottomSepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 150.5, 278.5, 1.5)];
    [bottomSepLine setBackgroundColor:RGBA(237.0, 237.0, 237.0, 1.0)];
    [timeBroadcastView addSubview:bottomSepLine];
    [self setYearScrollView];
    [self setMonthScrollView];
    [self setDayScrollView];
    [self setHourScrollView];
    [self setMinuteScrollView];
    //    [self setSecondScrollView];

    selectTimeIsNotLegalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-278.5/2, 339.5, 278.5, 15)];
    [selectTimeIsNotLegalLabel setBackgroundColor:[UIColor clearColor]];
    [selectTimeIsNotLegalLabel setFont:[UIFont systemFontOfSize:15.0]];
    [selectTimeIsNotLegalLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:selectTimeIsNotLegalLabel];
}
//设置年月日时分的滚动视图
- (void)setYearScrollView
{
    yearScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 73.0, 190.0)];
    NSInteger yearint = [self setNowTimeShow:0];
    [yearScrollView setCurrentSelectPage:(yearint-2002)];
    yearScrollView.delegate = self;
    yearScrollView.datasource = self;
    [self setAfterScrollShowView:yearScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:yearScrollView];
}
//设置年月日时分的滚动视图
- (void)setMonthScrollView
{
    monthScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(73.0, 0, 40.5, 190.0)];
    NSInteger monthint = [self setNowTimeShow:1];
    [monthScrollView setCurrentSelectPage:(monthint-3)];
    monthScrollView.delegate = self;
    monthScrollView.datasource = self;
    [self setAfterScrollShowView:monthScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:monthScrollView];
}
//设置年月日时分的滚动视图
- (void)setDayScrollView
{
    dayScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(113.5, 0, 46.0, 190.0)];
    NSInteger dayint = [self setNowTimeShow:2];
    [dayScrollView setCurrentSelectPage:(dayint-3)];
    dayScrollView.delegate = self;
    dayScrollView.datasource = self;
    [self setAfterScrollShowView:dayScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:dayScrollView];
}
//设置年月日时分的滚动视图
- (void)setHourScrollView
{
    hourScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(159.5, 0, 39.0, 190.0)];
    NSInteger hourint = [self setNowTimeShow:3];
    [hourScrollView setCurrentSelectPage:(hourint-2)];
    hourScrollView.delegate = self;
    hourScrollView.datasource = self;
    [self setAfterScrollShowView:hourScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:hourScrollView];
}
//设置年月日时分的滚动视图
- (void)setMinuteScrollView
{
    minuteScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(198.5, 0, 37.0, 190.0)];
    NSInteger minuteint = [self setNowTimeShow:4];
    [minuteScrollView setCurrentSelectPage:(minuteint-2)];
    minuteScrollView.delegate = self;
    minuteScrollView.datasource = self;
    [self setAfterScrollShowView:minuteScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:minuteScrollView];
}
////设置年月日时分的滚动视图
//- (void)setSecondScrollView
//{
//    secondScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(235.5, 0, 43.0, 190.0)];
//    NSInteger secondint = [self setNowTimeShow:5];
//    [secondScrollView setCurrentSelectPage:(secondint-2)];
//    secondScrollView.delegate = self;
//    secondScrollView.datasource = self;
//    [self setAfterScrollShowView:secondScrollView andCurrentPage:1];
//    [timeBroadcastView addSubview:secondScrollView];
//}
- (void)setAfterScrollShowView:(MXSCycleScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:14]];
    [oneLabel setTextColor:RGBA(186.0, 186.0, 186.0, 1.0)];
    UILabel *twoLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+1];
    [twoLabel setFont:[UIFont systemFontOfSize:16]];
    [twoLabel setTextColor:RGBA(113.0, 113.0, 113.0, 1.0)];

    UILabel *currentLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+2];
    [currentLabel setFont:[UIFont systemFontOfSize:18]];
    [currentLabel setTextColor:[UIColor whiteColor]];

    UILabel *threeLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+3];
    [threeLabel setFont:[UIFont systemFontOfSize:16]];
    [threeLabel setTextColor:RGBA(113.0, 113.0, 113.0, 1.0)];
    UILabel *fourLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+4];
    [fourLabel setFont:[UIFont systemFontOfSize:14]];
    [fourLabel setTextColor:RGBA(186.0, 186.0, 186.0, 1.0)];
}
#pragma mark mxccyclescrollview delegate
#pragma mark mxccyclescrollview databasesource
- (NSInteger)numberOfPages:(MXSCycleScrollView*)scrollView
{
    if (scrollView == yearScrollView) {
        return 99;
    }
    else if (scrollView == monthScrollView)
    {
        return 12;
    }
    else if (scrollView == dayScrollView)
    {
        return 31;
    }
    else if (scrollView == hourScrollView)
    {
        return 24;
    }
    else if (scrollView == minuteScrollView)
    {
        return 60;
    }
    return 60;
}
#pragma mark——显示时间的label
- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(MXSCycleScrollView *)scrollView
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height/5)];
    l.tag = index+1;
    if (scrollView == yearScrollView) {
        l.text = [NSString stringWithFormat:@"%ld",2000+index];
    }
    else if (scrollView == monthScrollView)
    {
        //🍎
        if (index<9) {
            l.text = [NSString stringWithFormat:@"0%ld月",1+index];
        }
        else
            //🍎
        l.text = [NSString stringWithFormat:@"%ld月",1+index];
    }
    else if (scrollView == dayScrollView)
    {//🍎
        if (index<9) {
            l.text = [NSString stringWithFormat:@"0%ld日",1+index];
        }
        else
            //🍎
        l.text = [NSString stringWithFormat:@"%ld日",1+index];
    }
    else if (scrollView == hourScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld",(long)index];
    }
    else /*if (scrollView == minuteScrollView)*/
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld",(long)index];
    }
//    else
//        if (index < 10) {
//            l.text = [NSString stringWithFormat:@"0%ld",(long)index];
//        }
//        else
//            l.text = [NSString stringWithFormat:@"%ld",(long)index];

    l.font = [UIFont systemFontOfSize:12];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    return l;
}
#pragma mark——设置当前时间
//设置现在时间
- (NSInteger)setNowTimeShow:(NSInteger)timeType
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    switch (timeType) {
        case 0:
        {
            NSRange range = NSMakeRange(0, 4);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 1:
        {
            NSRange range = NSMakeRange(4, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 2:
        {
            NSRange range = NSMakeRange(6, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 3:
        {
            NSRange range = NSMakeRange(8, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 4:
        {
            NSRange range = NSMakeRange(10, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
//        case 5:
//        {
//            NSRange range = NSMakeRange(12, 2);
//            NSString *yearString = [dateString substringWithRange:range];
//            return yearString.integerValue;
//        }
//            break;
        default:
            break;
    }
    return 0;
}
#pragma mark——设置播报时间
//选择设置的播报时间
- (void)selectSetBroadcastTime
{
    UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *dayLabel = [[(UILabel*)[[dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *secondLabel = [[(UILabel*)[[secondScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];

    NSInteger yearInt = yearLabel.tag + 1999;
    NSInteger monthInt = monthLabel.tag;
    NSInteger dayInt = dayLabel.tag;
    NSInteger hourInt = hourLabel.tag - 1;
    NSInteger minuteInt = minuteLabel.tag - 1;
//    NSInteger secondInt = secondLabel.tag - 1;
    NSString *taskDateString = [NSString stringWithFormat:@"%ld%02ld%02ld%02ld%02ld",(long)yearInt,(long)monthInt,(long)dayInt,(long)hourInt,(long)minuteInt/*,(long)secondInt*/];//%02ld
    
    YjqLog(@"Now----%@",taskDateString);
}
#pragma mark——滑动调整时间
//滚动时上下标签显示(当前时间和是否为有效时间)
- (void)scrollviewDidChangeNumber
{
    UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *dayLabel = [[(UILabel*)[[dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *secondLabel = [[(UILabel*)[[secondScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];

    NSInteger yearInt = yearLabel.tag + 1999;
    NSInteger monthInt = monthLabel.tag;
    NSInteger dayInt = dayLabel.tag;
    NSInteger hourInt = hourLabel.tag - 1;
    NSInteger minuteInt = minuteLabel.tag - 1;
//    NSInteger secondInt = secondLabel.tag - 1;
//    NSString *dateString = [NSString stringWithFormat:@"%ld%02ld%02ld%02ld%02ld%02ld",(long)yearInt,(long)monthInt,(long)dayInt,(long)hourInt,(long)minuteInt,(long)secondInt];
    //NSString *weekString = [self fromDateToWeek:dateString];
    nowPickerShowTimeLabel.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)yearInt,(long)monthInt,(long)dayInt,(long)hourInt,(long)minuteInt/*,(long)secondInt*/];//:%02ld
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.timeStr = nowPickerShowTimeLabel.text;
    NSLog(@"%@",self.timeStr);
    /**
     此处调用代理
     */
    if (self.FKdelegate && [self.FKdelegate respondsToSelector:@selector(giveTimeString:)]) {
        [self.FKdelegate giveTimeString:self.timeStr];
    }

    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *selectTimeString = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)yearInt,(long)monthInt,(long)dayInt,(long)hourInt,(long)minuteInt/*,(long)secondInt*/];//:%02ld
    NSDate *selectDate = [dateFormatter dateFromString:selectTimeString];
    NSDate *nowDate = [NSDate date];
    NSString *nowString = [dateFormatter stringFromDate:nowDate];
    NSDate *nowStrDate = [dateFormatter dateFromString:nowString];
    if (NSOrderedAscending == [selectDate compare:nowStrDate]) {//选择的时间与当前系统时间做比较
        [selectTimeIsNotLegalLabel setTextColor:RGBA(155, 155, 155, 1)];
        selectTimeIsNotLegalLabel.text = @"温馨提示：所选时间不合法，无法提交";
        [OkBtn setEnabled:NO];
    }
    else
    {
       // selectTimeIsNotLegalLabel.text = self.timeStr;

    selectTimeIsNotLegalLabel.text = @"";
        [OkBtn setEnabled:YES];
    }
}
//通过日期求星期
- (NSString*)fromDateToWeek:(NSString*)selectDate
{
    NSInteger yearInt = [selectDate substringWithRange:NSMakeRange(0, 4)].integerValue;
    NSInteger monthInt = [selectDate substringWithRange:NSMakeRange(4, 2)].integerValue;
    NSInteger dayInt = [selectDate substringWithRange:NSMakeRange(6, 2)].integerValue;
    int c = 20;//世纪
   long int y = yearInt -1;//年
    long int d = dayInt;
   long int m = monthInt;
    int w =(y+(y/4)+(c/4)-2*c+(26*(m+1)/10)+d-1)%7;
    NSString *weekDay = @"";
    switch (w) {
        case 0:
            weekDay = @"周日";
            break;
        case 1:
            weekDay = @"周一";
            break;
        case 2:
            weekDay = @"周二";
            break;
        case 3:
            weekDay = @"周三";
            break;
        case 4:
            weekDay = @"周四";
            break;
        case 5:
            weekDay = @"周五";
            break;
        case 6:
            weekDay = @"周六";
            break;
        default:
            break;
    }
    return weekDay;
}

@end
