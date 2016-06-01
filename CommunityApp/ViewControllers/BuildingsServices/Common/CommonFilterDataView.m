//
//  CommonFilterDataView.m
//  CommunityApp
//
//  Created by iss on 7/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "CommonFilterDataView.h"


@implementation CommonFilterDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if(self)
    {
        //[self initView:frame];
         self.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0f alpha:1];
    }
    return self;
}
-(UIButton *)buttonWithTag:(NSInteger)tag
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(filterTableDisplay:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    return btn;
}
-(void) filterTableDisplay:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(FilterTableData:filter:)]) {
        UIButton* btn = sender;
        NSArray* array =[ [NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%ld", (long)btn.tag], nil];
        [self.delegate FilterTableData:self filter:array];
    }
}
-(UIButton*) createTitleBtn:(NSString*)title withFrame:(CGRect)frame withTag:(NSInteger)tag
{
    UIButton* btn  = [self buttonWithTag:tag] ;
    [btn setFrame:frame];
    [btn setTitleColor:[UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    UIImage* arrow = [UIImage imageNamed:@"DownArrowNor"];
    [btn setImage:arrow forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [self arrangementBtn:btn];
    return btn;
}

-(void) initFilterTitle:(NSArray*)filterTitle
{
    if(filterTitle == nil)
        return;
    NSInteger btnCount = filterTitle.count;
    NSInteger dividingLineWidth = 1;
    NSInteger dividingLineHeight = 35;
    CGRect frame = self.frame;
    NSInteger btnWidth = (frame.size.width-dividingLineWidth*(btnCount-1))/btnCount;
    
    static NSInteger tagStart = 1;
    NSInteger tag = tagStart;
    for(NSInteger i = 0; i< btnCount;i++)
    {
        
        CGRect btnFrame = CGRectMake(i*(btnWidth+dividingLineWidth), 0, btnWidth, frame.size.height);
        UIButton* btn = [self createTitleBtn:[filterTitle objectAtIndex:i] withFrame:btnFrame withTag:tag];
        [self addSubview:btn];
        if(i<btnCount-1)
        {
            CGRect lineFrame = CGRectMake((i+1)*btnWidth+dividingLineWidth*i, (frame.size.height-dividingLineHeight)/2, dividingLineWidth, dividingLineHeight);
            UIImageView* line = [[UIImageView alloc]initWithFrame:lineFrame];
            [line setBackgroundColor:[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/244.0f alpha:1]];
            [self addSubview:line];
        }
        
        tag++;
        
    }

}
-(void) setFilterTitle:(NSInteger)tag title:(NSString*)title
{
    UIButton* btn = (UIButton*)[self viewWithTag:tag];
    if(btn)
    {
        [btn setTitle:title forState:UIControlStateNormal];
        [self arrangementBtn:btn];
        
    }
}
-(void)arrangementBtn:(UIButton*)btn
{
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -18, 0, 18)];
    // CGSize titleSize = [btn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize: 15.0]];
    CGFloat width = [self getTitleWidth:btn.titleLabel.text];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, width, 0, -width)];

}
-(CGFloat) getTitleWidth:(NSString*)title
{
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect tmpRect = [title boundingRectWithSize:CGSizeMake(Screen_Width, 2000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return tmpRect.size.width;
}
@end
