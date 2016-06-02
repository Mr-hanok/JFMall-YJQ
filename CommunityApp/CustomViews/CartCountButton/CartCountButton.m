//
//  CartCountButton.m
//  CommunityApp
//
//  Created by issuser on 15/6/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CartCountButton.h"

@interface CartCountButton () {
    NSString *_preNumber;
}

@end

@implementation CartCountButton


+ (id)instanceCartButton
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CartCountButton" owner:nil options:nil];
    CartCountButton *countBtn = [nibView objectAtIndex:0];
    if (countBtn) {
        countBtn.frame = CGRectMake(0, 0, 90, 30);
        countBtn.countTextField.delegate = countBtn;
        [[NSNotificationCenter defaultCenter] addObserver:countBtn selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:countBtn.countTextField];
    }
    return countBtn;
}


// 初始化购物车数量
- (void)initCartCount:(NSInteger)count
{
    self.count = count;
    [self.countTextField setText:[NSString stringWithFormat:@"%ld",count]];
}

#pragma mark - 按钮点击事件处理函数
// 减少按钮
- (IBAction)minusBtnClickHandler:(id)sender
{
    if (self.countTextField.text.integerValue-1 < 0) {
        return;
    }
    
    self.count = [self.countTextField.text integerValue];
    if (self.count > 1) {
        self.count --;
        [self.countTextField setText: [NSString stringWithFormat:@"%ld",self.count]];
        if (self.cartCountChangeBlock) {
            self.cartCountChangeBlock(self.count);
        }
        if([self.delegate respondsToSelector:@selector(cartCountChange:)])
        {
            [self.delegate cartCountChange:self.count];
        }
    }
    
}

// 增加按钮
- (IBAction)plusBtnClickHandler:(id)sender
{
    if (self.countTextField.text.integerValue+1 > 999) {
        return;
    }
    
    self.count = [self.countTextField.text integerValue];
    self.count ++;
    [self.countTextField setText: [NSString stringWithFormat:@"%ld",self.count]];
    if (self.cartCountChangeBlock) {
        self.cartCountChangeBlock(self.count);
    }
    if([self.delegate respondsToSelector:@selector(cartCountChange:)])
    {
        [self.delegate cartCountChange:self.count];
    }
}


#pragma mark - TextFiled代理

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self validateNumber:string]) {
        _preNumber = textField.text;
        return YES;
    }
    else {
        return NO;
    }
}

// UITextField变更通知处理函数
- (void)textFieldDidChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)[notification object];
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"1";
    }
    else if (textField.text.integerValue > 999) {
        textField.text = _preNumber.integerValue > 999 ? @"999" : _preNumber;
    }
    
    NSInteger count = [textField.text integerValue];
    if (self.cartCountChangeBlock) {
        self.cartCountChangeBlock(count);
    }
    self.count = count;
    
    if([self.delegate respondsToSelector:@selector(cartCountChange:)])
    {
        [self.delegate cartCountChange:self.count];
    }
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


@end
