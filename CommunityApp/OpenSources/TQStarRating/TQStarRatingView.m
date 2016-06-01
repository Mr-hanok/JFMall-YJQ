//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "TQStarRatingView.h"

@interface TQStarRatingView ()

@property (nonatomic, strong) UIImageView *back;
@property (nonatomic, strong) UIImageView *fore;
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation TQStarRatingView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:kNUMBER_OF_STAR];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _numberOfStar = kNUMBER_OF_STAR;
    [self commonInit];
}

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.isEdit = TRUE;
    self.Rounding = TRUE;
    
    [self.starBackgroundView removeFromSuperview];
    [self.starForegroundView removeFromSuperview];
    
    self.starBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.starForegroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    [self.starBackgroundView setClipsToBounds:YES];
    [self.starForegroundView setClipsToBounds:YES];

    self.back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Img_Bussiness_BackgroundStar]];
    self.fore = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Img_Bussiness_ForegroundStar]];
    [self.back setFrame:self.bounds];
    [self.fore setFrame:self.bounds];
    
    [self.starBackgroundView addSubview:self.back];
    [self.starForegroundView addSubview:self.fore];
    
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
}

#pragma mark -
#pragma mark - Set Score

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate
{
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished){}];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion
{
    if (score < 0)
    {
        score = 0;
    }
    
    if (score > 1)
    {
        score = 1;
    }
    
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate)
    {
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^
         {
             [weakSelf changeStarForegroundViewWithPoint:point];
             
         } completion:^(BOOL finished)
         {
             if (completion)
             {
                 completion(finished);
             }
         }];
    }
    else
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark -
#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isEdit)
    {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        if(CGRectContainsPoint(rect,point))
        {
            [self changeStarForegroundViewWithPoint:point];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isEdit) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^
         {
             [weakSelf changeStarForegroundViewWithPoint:point];
         }];
    }
}
#pragma mark -
#pragma mark - Change Star Foreground With Point

/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    NSString * str;
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    
    if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    if (self.Rounding)
    {
        str = [NSString stringWithFormat:@"%0.1f",p.x / self.frame.size.width];
    }
    else
    {
        str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    }
    
    float score = [str floatValue];
    int iScore = (int)(score*10);
    if (iScore%2 > 0) {
        score += 0.1;
    }
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
    {
        [self.delegate starRatingView:self score:score];
    }
}

@end
