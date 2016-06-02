//
//  openDoorAnimation.m
//  CommunityApp
//
//  Created by lsy on 15/11/5.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "OpenDoorAnimation.h"
#import "UIImage+animatedGIF.h"
//Logo半径（画布）
NSInteger const Logo_Size = 40;

@interface OpenDoorAnimation()
{
    UIView * _logoView;//画布
    UILabel * _titleLabel;//标题
    
}

@end
@implementation OpenDoorAnimation
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = (CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size};
        self.alpha = 1;
        [self setBackgroundColor:[UIColor clearColor]];
        self.hidden = NO;//不隐藏
        self.windowLevel = UIWindowLevelAlert;
        [self makeKeyAndVisible];
        
        [self logoInit];
    }
    
    return self;
}

#pragma mark- 单利
+(instancetype)share
{
    static dispatch_once_t once=0;
    static OpenDoorAnimation *alert;
    dispatch_once(&once,^{
        alert=[[OpenDoorAnimation alloc]init];
    });
    return alert;
}
#pragma mark-  显示动画
+(instancetype)showOpenDoorAnimation:(NSString *)openTimeString andSuccessOrFail:(int)signNum
{
    [[self share]gifAnimation:openTimeString andSuccessOrFail:signNum];
    return [self share];
}
//显示弹窗
#pragma mark-显示弹窗
+(instancetype)showGiveToken
{
    [[self share]giveToken];
    return [self share];
}

- (void)giveToken
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
    imageview.image = [UIImage imageNamed:@"cashcoupona_bg.jpg"];


    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 50, 50)];
    [cancelBtn setImage:[UIImage imageNamed:@"cashcoupona_cancel.jpg"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];

    [imageview addSubview:cancelBtn];
    [self.window addSubview:imageview];
}
- (void)cancelBtn:(UIButton *)btn
{
    self.window.hidden = NO;
}
#pragma mark-  开门成功设计方法
-(void)gifAnimation:(NSString*)openTimeStr andSuccessOrFail:(int)num
{

    [self logoInit];
    if (num==0) {
        //添加动画
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(80,50,40 ,45)];
        NSString * filePath = [[NSBundle mainBundle]pathForResource:@"开门效果" ofType:@"gif"];
        NSURL * fileUrl = [NSURL fileURLWithPath:filePath];//这个方法用来进行本地地下的转换
        NSData * data = [[NSData alloc]initWithContentsOfURL:fileUrl];
        UIImage * image = [UIImage animatedImageWithAnimatedGIFData:data];
        imageView.image = image;
        [_logoView addSubview:imageView];
        //添加开门成功提示语
        UILabel*openSuccessLabel=[[UILabel alloc]initWithFrame:CGRectMake(140,60,_logoView.frame.size.width-70, 30)];
        openSuccessLabel.text=@"开门成功!";
        openSuccessLabel.backgroundColor=[UIColor whiteColor];
        [_logoView addSubview:openSuccessLabel];
        
        //添加线条
        UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0,150,_logoView.frame.size.width, 1)];
        lineView.backgroundColor=[UIColor grayColor];
        [_logoView addSubview:lineView];
        
        //添加开门的时间
        UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, lineView.frame.origin.y+5, _logoView.frame.size.width, 50)];
        //开门时间str
        timeLabel.text=[NSString stringWithFormat:@"%@ S",openTimeStr];
        timeLabel.textAlignment=NSTextAlignmentCenter;
        timeLabel.textColor=[UIColor grayColor];
        [_logoView addSubview:timeLabel];
    }
    if (num==1) {
        //添加动画
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(80,50,40 ,45)];
        imageView.image=[UIImage imageNamed:@"opendoor_failed.png"];
//        NSString * filePath = [[NSBundle mainBundle]pathForResource:@"开门效果" ofType:@"gif"];
//        NSURL * fileUrl = [NSURL fileURLWithPath:filePath];//这个方法用来进行本地地下的转换
//        NSData * data = [[NSData alloc]initWithContentsOfURL:fileUrl];
//        UIImage * image = [UIImage animatedImageWithAnimatedGIFData:data];
//        imageView.image = image;
        [_logoView addSubview:imageView];
        //添加开门成功提示语
        UILabel*openSuccessLabel=[[UILabel alloc]initWithFrame:CGRectMake(140,60,_logoView.frame.size.width-70, 30)];
        openSuccessLabel.text=@"开门失败!";
        openSuccessLabel.backgroundColor=[UIColor whiteColor];
        [_logoView addSubview:openSuccessLabel];
        
        //添加线条
        UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0,150,_logoView.frame.size.width, 1)];
        lineView.backgroundColor=[UIColor grayColor];
        [_logoView addSubview:lineView];
        
        //添加开门的时间
        UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, lineView.frame.origin.y+5, _logoView.frame.size.width, 50)];
        //开门时间str
        timeLabel.text=[NSString stringWithFormat:@"%@ S",openTimeStr];
        timeLabel.textAlignment=NSTextAlignmentCenter;
        timeLabel.textColor=[UIColor grayColor];
        [_logoView addSubview:timeLabel];
    }
    
   
}
#pragma mark-创建画布
//warning 需完善画布的清除，不适用移除，新建的办法
- (void)logoInit
{
//    //移除画布
//    [_logoView removeFromSuperview];
//    _logoView = nil;
    //新建画布
    _logoView                     = [UIView new];
    _logoView.center              = CGPointMake(self.center.x, self.center.y+20);
    _logoView.bounds              = CGRectMake(0,0,self.frame.size.height / 2, self.frame.size.width / 1.5);
    _logoView.backgroundColor     = [UIColor whiteColor];
    _logoView.layer.cornerRadius  = 10;
    _logoView.layer.shadowColor   = [UIColor blackColor].CGColor;
    _logoView.layer.shadowOffset  = CGSizeMake(0, 5);
    _logoView.layer.shadowOpacity = 0.3f;
    _logoView.layer.shadowRadius  = 10.0f;
    
    //保证画布位于所有视图层级的最下方
    if (_titleLabel != nil) {
        [self insertSubview:_logoView belowSubview:_titleLabel];
    }
    else
        [self addSubview:_logoView];
}

@end
