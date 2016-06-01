//
//  UILabel+Price.m
//
//  Created by Andrew on 15/7/24.
//  Copyright (c) 2015年 com.iss. All rights reserved.
//

#import "UILabel+Price.h"

@implementation UILabel (Price)

- (void)setNewPrice:(NSString *)newPrice oldPrice:(NSString *)oldPrice
{
    NSString *midBlank = @"  ";
    NSString *allPrice = [NSString stringWithFormat:@"￥%@%@￥%@", newPrice, midBlank, oldPrice];
    
    NSRange newRange = {0, newPrice.length+1};
    NSRange oldRange = {newRange.location+newRange.length+midBlank.length, oldPrice.length+1};
    
    UIColor *newColor = [UIColor orangeColor];
    UIColor *oldColor = [UIColor colorWithRed:131.0/255 green:131.0/255 blue:131.0/255 alpha:1.0];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:allPrice];
    
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:oldRange];
    [attri addAttribute:NSStrikethroughColorAttributeName value:oldColor range:oldRange];
    
    [attri addAttribute:NSForegroundColorAttributeName value:newColor range:newRange];
    [attri addAttribute:NSForegroundColorAttributeName value:oldColor range:oldRange];
    [self setAttributedText:attri];
}
-(void)setLabelTextString:(NSString *)textString andWithStringColor:(UIColor *)stringColor andWirhLineColor:(UIColor *)lilneColor
{
    NSRange rang={0,textString.length+1};
    NSMutableAttributedString*string=[[NSMutableAttributedString alloc]initWithString:textString];
    //设置划线的范围和颜色
    [string addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid|NSUnderlineStyleSingle) range:rang];
    [string addAttribute:NSStrikethroughColorAttributeName value:lilneColor range:rang];
    //设置Labeltext颜色
    [string addAttribute:NSForegroundColorAttributeName value:stringColor range:rang];
    [self setAttributedText:string];
}
- (void)setSpecialPrice:(NSString *)specialPrice OrangPrice:(NSString *)orangPrice
{
    NSString *midBlank = @"  ";
    NSString *allPrice = [NSString stringWithFormat:@"特价:￥%@%@原价:￥%@", specialPrice, midBlank, orangPrice];

    NSRange newRange = {0, specialPrice.length+4};
    NSRange oldRange = {newRange.location+newRange.length+midBlank.length, orangPrice.length+4};

    UIColor *newColor = [UIColor orangeColor];
    UIColor *oldColor = [UIColor colorWithRed:131.0/255 green:131.0/255 blue:131.0/255 alpha:1.0];

    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:allPrice];

    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:oldRange];
    [attri addAttribute:NSStrikethroughColorAttributeName value:oldColor range:oldRange];

    [attri addAttribute:NSForegroundColorAttributeName value:newColor range:newRange];
    [attri addAttribute:NSForegroundColorAttributeName value:oldColor range:oldRange];
    [self setAttributedText:attri];
}

- (void)setPart1:(NSString *)part1 color1:(UIColor *)color1 part2:(NSString *)part2 color2:(UIColor *)color2
{
    NSString *midBlank = @"  ";
    NSString *allPrice = [NSString stringWithFormat:@"%@%@%@", part1, midBlank, part2];
    
    NSRange newRange = {0, part1.length};
    NSRange oldRange = {newRange.location+newRange.length+midBlank.length, part2.length};
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:allPrice];
    
    [attri addAttribute:NSForegroundColorAttributeName value:color1 range:newRange];
    [attri addAttribute:NSForegroundColorAttributeName value:color2 range:oldRange];
    [self setAttributedText:attri];
}

@end
