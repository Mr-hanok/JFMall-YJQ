//
//  PersonalCenterMyOrderHeadView.m
//  CommunityApp
//
//  Created by iss on 7/8/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderHeadView.h"
@interface PersonalCenterMyOrderHeadView()
@property (strong,nonatomic) UILabel* orderCreateTime;
@property (strong,nonatomic) UILabel* orderId;
@property (strong,nonatomic) UILabel* orderState;
@property (strong,nonatomic) UIImageView* imgTop;
@end
@implementation PersonalCenterMyOrderHeadView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData:frame];
    }
    return self;
    
}

-(void)initData:(CGRect)frame
{
    self.imgTop = [[UIImageView alloc]init];
    [self.imgTop setImage:[UIImage imageNamed:Img_MyCouponList_Head]];
    [self addSubview:self.imgTop];
    UIFont* font = [UIFont systemFontOfSize:13];
    self.orderCreateTime = [[UILabel alloc]initWithFrame:(CGRectMake(8, 8, 128, 21))];
    self.orderCreateTime.font =font;
    self.orderCreateTime.textColor = [UIColor colorWithRed:125/255.0f green:125/255.0f blue:125/255.0f alpha:1];
    [self addSubview:_orderCreateTime];
    
    self.orderId = [[UILabel alloc]initWithFrame:(CGRectMake(8, CGRectGetMaxY(self.orderCreateTime.bounds)+8, 120, 21))];
    self.orderId.font =font;
    [self addSubview:_orderId];
    
    self.orderState = [[UILabel alloc]init];
    self.orderState.font =font;
    self.orderState.textColor = [UIColor colorWithRed:235/255.0f green:114/255.0f blue:25/255.0f alpha:1];
    [self addSubview:_orderState];
}

-(void)setViewFrame:(CGRect)frame
{
    self.frame = frame;
    self.imgTop.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.orderState.frame = CGRectMake(frame.size.width-40-8, 8, 40, 21);
    self.orderId.frame = (CGRectMake(8, CGRectGetMaxY(self.orderCreateTime.bounds)+8, frame.size.width-8, 21));
    UIView* bg = [[UIView alloc]initWithFrame:frame ];
    [bg setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundView: bg];
}
-(void)setHeadText:(NSString *)time orderId:(NSString*)Id state:(NSString*)state
{
    if (time.length > 0) {
          [_orderCreateTime  setText:time];
    }

    [_orderId setText:[NSString stringWithFormat:@"NO.%@",Id]];
    [_orderState setText:state];

    self.orderstr = Id;//11-27
}
@end
