//
//  CartBottomBar.h
//  CommunityApp
//
//  Created by issuser on 15/6/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum ECartBottomType{
    E_CartBottomType_Normal,
    E_CartBottomType_IntoCart,
    E_CartBottomType_Last
}eCartBottomType;


@interface CartBottomBar : UIView
@property (retain, nonatomic) IBOutlet UILabel *leftLabel;
@property (retain, nonatomic) IBOutlet UIButton *rightBtn;
@property (retain, nonatomic) IBOutlet UIView *leftCartView;
@property (retain, nonatomic) IBOutlet UIButton *leftCartCountBtn;
@property (assign, nonatomic) NSInteger totalCount;
@property (assign, nonatomic) eCartBottomType   cartType;

@property (nonatomic, copy) void(^totalCountChangeBlock)(NSInteger);


@property (nonatomic, copy) void(^rightBtnClickBlock)(void);
@property (nonatomic, copy) void(^leftBtnClickBlock)(void);



+ (id)instanceCartBottomBar;


- (void)setCartBottomType:(eCartBottomType)type;


@end
