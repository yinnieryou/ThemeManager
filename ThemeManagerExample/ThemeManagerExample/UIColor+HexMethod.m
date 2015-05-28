//
//  UIColor+HexMethod.m
//  ThemeManagerExample
//
//  Created by yinnieryou on 14-9-11.
//  Copyright (c) 2014年 yinnieryou. All rights reserved.
//

#import "UIColor+HexMethod.h"

@implementation UIColor (HexMethod)

/**
 *  以255颜色值设置RGB
 *
 *  @param red   红色的255值
 *  @param green 绿色的255值
 *  @param blue  蓝色的255值
 *  @param alpha 透明度
 *
 *  @return uicolor
 */
+ (UIColor *)color255WithRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha{
    
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
}

/**
 *  十六进制色值表示
 *
 *  @param hexString 十六进制色值字符串
 *  @param alpha     透明度
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(int)alpha{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (alpha < 1) {
        alpha = alpha * 255.0f;
    }
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha: (float)alpha/255.0];
}

/**
 *  十六进制色值表示
 *
 *  @param hexString 十六进制色值字符串
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString{
    return [UIColor colorWithHexString:hexString alpha:255];
}

@end
