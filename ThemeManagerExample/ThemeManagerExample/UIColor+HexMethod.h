//
//  UIColor+HexMethod.h
//  ThemeManagerExample
//
//  Created by yinnieryou on 14-9-11.
//  Copyright (c) 2014年 yinnieryou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexMethod)

+ (UIColor *)color255WithRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(int)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
