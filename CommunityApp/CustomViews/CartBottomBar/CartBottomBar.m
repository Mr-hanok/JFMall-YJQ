//
//  CartBottomBar.m
//  CommunityApp
//
//  Created by issuser on 15/6/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CartBottomBar.h"

@interface CartBottomBar()
@property (retain, nonatomic) IBOutlet UIView *totalView;
@property (retain, nonatomic) IBOutlet UIView *settleView;

@end

@implementation CartBottomBar

//static CartBottomBar *instance = nil;

+ (CartBottomBar *)instanceCartBottomBar
{
    //    @synchronized(self)
    //    {
    
    
//    static CartBottomBar *instance;
    CartBottomBar *instance;
    if (instance == nil) {
        NSArray *cartBot = [[NSBundle mainBundle] loadNibNamed:@"CartBottomBar" owner:nil options:nil];
        //            instance = [dd lastObject];
        CartBottomBar *barCart = [cartBot objectAtIndex:cartBot.count-1];
        //            NSLog(@"－－－－－－－－－－－－%@", instance);
        instance = (CartBottomBar*)barCart;
        //            NSLog(@"+++++++++++++++++%@", instance);
        instance.frame = CGRectMake(0, 0, Screen_Width, 50);
        instance.cartType = E_CartBottomType_Normal;
        instance.leftCartView.hidden = YES;
        [instance.leftCartCountBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    //    }
    
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        if (instance == nil)
    //        {
    //            instance = [super allocWithZone:zone];
    //        }
    //    });
    //    return instance;
    if (zone == nil) {
        return [super allocWithZone:zone];
    }
    return [self instanceCartBottomBar];
}



// 设置是否显示购物车
- (void)setCartBottomType:(eCartBottomType)type
{
    self.cartType = type;
    if (self.cartType == E_CartBottomType_IntoCart) {
        self.leftLabel.hidden = YES;
        self.leftCartView.hidden = NO;
    }
    else {
        self.leftCartView.hidden = YES;
        self.leftLabel.hidden = NO;
    }
}

#pragma mark - 按钮点击事件处理函数
// 立即结算按钮点击事件
- (IBAction)rightBtnClickHandler:(id)sender
{
    if (self.rightBtnClickBlock) {
        self.rightBtnClickBlock();
    }
}
- (IBAction)leftBtnClickHandler:(id)sender {
    if (self.leftBtnClickBlock) {
        self.leftBtnClickBlock();
    }
}


- (void)setTotalCount:(NSInteger)totalCount
{
    if(_totalCount != totalCount)
    {
        _totalCount = totalCount;
        if (self.totalCountChangeBlock) {
            self.totalCountChangeBlock(_totalCount);
        }
    }
    
}

@end
