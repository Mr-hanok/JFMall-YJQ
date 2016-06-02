//
//  QuestionContentListHeadView.m
//  CommunityApp
//
//  Created by iss on 6/15/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "QuestionContentListHeadView.h"
@interface QuestionContentListHeadView()
@property(strong,nonatomic)UIImageView* line;
@property(strong,nonatomic)UILabel* title;
@end
@implementation QuestionContentListHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    [self setBackgroundColor:[UIColor clearColor]];
//    self.line = [[UIImageView alloc]initWithFrame:CGRectMake(5, 39, frame.size.width, 1)];
//    [self addSubview:_line];
//    [_line setBackgroundColor:COLOR_RGB(220, 220, 220)];
    self.title = [[UILabel alloc]initWithFrame:(CGRectMake(10, 10, frame.size.width-20, 20))];
    UIImage* img = [UIImage imageNamed:Img_Survey_Top];
    UIImageView* bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
    [bg setImage:img];
    [self addSubview:bg];
    [self addSubview:_title];
}

-(void)setTitleText:(NSString *)title
{
    [self.title setText:title];
}
@end
