//
//  CartCountButton.h
//  CommunityApp
//
//  Created by issuser on 15/6/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CartCountButtonDelegate <NSObject>

@optional
- (void)cartCountChange:(NSInteger)count;

@end

@interface CartCountButton : UIView<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIButton *minusBtn;
@property (retain, nonatomic) IBOutlet UIButton *plusBtn;
@property (retain, nonatomic) IBOutlet UITextField *countTextField;

@property (nonatomic, assign) NSInteger         count;     //数量值
@property (assign,nonatomic)id<CartCountButtonDelegate> delegate;

+ (id)instanceCartButton;

/**
 * 初始化购物车购物数量
 */
- (void)initCartCount:(NSInteger)count;


@property (nonatomic, copy) void(^cartCountChangeBlock)(NSInteger);

@end
