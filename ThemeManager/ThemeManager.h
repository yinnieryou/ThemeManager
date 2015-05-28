//
//  SSBThemeManager.h
//  customTabbarController
//
//  Created by yinnieryou on 15/1/28.
//  Copyright (c) 2015年 yinnieryou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ThemeManagerMacro.h"
#import "UIColor+HexMethod.h"

//Theme name(DaytimeTheme(default) and NighttimeTheme)
#define kDaytimeTheme     @"DaytimeTheme"
#define kNighttimeTheme   @"NighttimeTheme"
#define kDefaultTheme     kDaytimeTheme

//animation duration
#define KThemeChangeAnimationDuration 0.5f
#define kThemeChangeDelayDuration 0.0

/**
 *  @author yinnieryou, 2015-04-10 17:04:21
 *
 *  @brief  notification name(before change theme it will post this notifiation)
 */
extern NSString *const kThemeManagerShouldChangeTheme;

@interface ThemeManager : NSObject

/**
 *  @author yinnieryou, 2015-04-10 17:04:51
 *
 *  @brief sharedManager
 *
 *  @return instance of ThemeManager
 */
+(instancetype)sharedManager;

/**
 *  @author yinnieryou, 2015-04-10 17:04:37
 *
 *  @brief  name of current theme
 */
@property (nonatomic, strong) NSString *currentThemeName;

/**
 *  @author yinnieryou, 2015-04-10 17:04:09
 *
 *  @brief  change the theme
 *
 *  @param themeName which theme would you like to change
 *  @param isNotify  post a notification or not
 */
-(void)changeTheme:(NSString *)themeName shouldNotify:(BOOL)isNotify;

/**
 *  @author yinnieryou, 2015-04-10 17:04:29
 *
 *  @brief  get the font from the plist file by the key
 *
 *  @param keyOfFont keyOfFont
 *
 *  @return UIFont
 */
-(UIFont *)fontForKey:(NSString *)keyOfFont;
/**
 *  @author yinnieryou, 2015-04-10 17:04:32
 *
 *  @brief  get the color by key
 *
 *  @param keyOfColor keyOfColor
 *
 *  @return UIColor
 */
-(UIColor *)colorForKey:(NSString *)keyOfColor;

/**
 *  @author yinnieryou, 2015-04-10 17:04:51
 *
 *  @brief  get the image by the name of image
 *
 *  @param nameOfImage nameOfImage
 *
 *  @return UIImage
 */
-(UIImage *)imageForImageName:(NSString *)nameOfImage;

@end
