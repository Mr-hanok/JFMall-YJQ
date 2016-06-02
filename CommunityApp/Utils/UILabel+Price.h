//
//  UILabel+Price.h
//
//  Created by Andrew on 15/7/24.
//  Copyright (c) 2015年 com.iss. All rights reserved.
//

@interface UILabel (Price)
//设置Label内容的，不同字段的
- (void)setNewPrice:(NSString *)newPrice oldPrice:(NSString *)oldPrice;

//设置Label字符串画一道线，字符串的颜色,和线条的颜色
- (void)setLabelTextString:(NSString*)textString andWithStringColor:(UIColor*)stringColor andWirhLineColor:(UIColor*)lilneColor;

- (void)setSpecialPrice:(NSString *)specialPrice OrangPrice:(NSString *)orangPrice;
- (void)setPart1:(NSString *)part1 color1:(UIColor *)color1 part2:(NSString *)part2 color2:(UIColor *)color2;

@end
