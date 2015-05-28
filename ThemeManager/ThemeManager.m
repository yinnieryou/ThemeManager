//
//  ThemeManager.m
//  ThemeManagerExample
//
//  Created by yinnieryou on 15/1/28.
//  Copyright (c) 2015年 yinnieryou. All rights reserved.
//

#import "ThemeManager.h"
#import <CoreText/CoreText.h>

//key of current theme (store into UserDefault)
#define CurrentTheme @"CurrentThemeName"

//the plist name of color and font
#define ColorPlist @"color"
#define FontPlist @"font"

//the folder name of image
#define ImagesDocument @"images"

//default font size
#define DefaultFontSize 15

NSString * const kThemeManagerShouldChangeTheme = @"kThemeManagerShouldChangeTheme";

@interface ThemeManager()

@property (nonatomic, strong, readwrite) NSDictionary *colorStyles; //color plist value
@property (nonatomic, strong, readwrite) NSDictionary *fontStyles; //font plist value
@property (nonatomic, strong, readwrite) NSString *imagePath; //image path

@property (nonatomic, strong, readwrite) NSString *bundlePath;

@end

@implementation ThemeManager

/**
 *  instace
 *
 *  @return instancetype
 */
+ (instancetype)sharedManager
{
    static ThemeManager *_themeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _themeManager = [[ThemeManager alloc]init];
    });
    return _themeManager;
}

/**
 *  initial
 *
 *  @return instancetype
 */
-(instancetype)init
{
    if(self = [super init])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *themeName = [defaults objectForKey:CurrentTheme];
        if (!themeName) // if themeName = nil use default theme.
        {
            themeName = kDefaultTheme;
        }
        [self changeTheme:themeName shouldNotify:NO];
    }
    return self;
}

/**
 *  change theme
 *
 *  @param themeName themeName
 *  @param isNotify  post a notification or not
 */
-(void)changeTheme:(NSString *)themeName shouldNotify:(BOOL)isNotify
{
    if (![themeName isEqualToString:self.currentThemeName])
    {
        self.currentThemeName = themeName;
        NSLog(@"current theme is %@",themeName);
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:_currentThemeName ofType:@"bundle"];
        
        // if your files are in a framework, you can get their like bellow.
//        NSBundle *frameworkBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] privateFrameworksPath]];
//        NSString *path = [frameworkBundle pathForResource:@"yinnieryou" ofType:@"framework"];
//        NSString *bundlePath = [[NSBundle bundleWithPath:path] pathForResource:_currentThemeName ofType:@"bundle"];
        
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath]; //get the bundle
        
        NSString *colorPath = [bundle pathForResource:ColorPlist ofType:@"plist"];
        self.colorStyles = [NSDictionary dictionaryWithContentsOfFile:colorPath];
        
        NSString *fontPath = [bundle pathForResource:FontPlist ofType:@"plist"];
        self.fontStyles = [NSDictionary dictionaryWithContentsOfFile:fontPath];
        
        self.imagePath = [bundle pathForResource:ImagesDocument ofType:nil];
        
        if (isNotify)
        {
           [[NSNotificationCenter defaultCenter] postNotificationName:kThemeManagerShouldChangeTheme object:nil];//post notification call someone change theme.
        }
    }
}

/**
 *  set the current theme
 *
 *  @param currentThemeName name
 */
-(void)setCurrentThemeName:(NSString *)currentThemeName
{
    _currentThemeName = currentThemeName;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_currentThemeName forKey:CurrentTheme];
    [defaults synchronize];
}

#pragma mark - Fonts
/**
 *  get the font
 *  
 *  key:value(Dictionary)
 *      [fontPath:value]
 *      [fontName:value]
 *      [fontSize:value]
 *
 *  @param keyOfFont keyOfFont
 *
 *  @return UIFont
 */
-(UIFont *)fontForKey:(NSString *)keyOfFont
{
    NSDictionary *fontProperties = self.fontStyles[keyOfFont];
    if (fontProperties)
    {
        NSString *fontPath = fontProperties[@"fontPath"]; //third part font path
        NSString *fontName = fontProperties[@"fontName"]; //if empty will use default
        float fontSize = [fontProperties[@"fontSize"] floatValue] ?:DefaultFontSize;
        if(![fontPath isEqualToString:@""]) //get the font from bundle
        {
            return [self registFontFromBundle:fontPath fontName:fontName fontSize:fontSize];
        }
        else if([fontName isEqualToString:@""]) //system font
        {
            return [UIFont systemFontOfSize:fontSize];
        }
        else
        {
            return [UIFont fontWithName:fontName size:fontSize];
        }
    }
    return [UIFont systemFontOfSize:DefaultFontSize];
}

#pragma mark - Colors
/**
 *  get color
 *
 *  @param keyOfColor keyOfColor
 *
 *  @return UIColor
 */
-(UIColor *)colorForKey:(NSString *)keyOfColor
{
    NSString *hexString = self.colorStyles[keyOfColor];
    if (hexString)
    {
        return [UIColor colorWithHexString:hexString];
    }
    return [UIColor whiteColor];
}

#pragma mark - Images
/**
 *  get the images
 *
 ***************************************
 **** Important: the image in diffrent bundle must have same name.
 ***************************************
 *
 *  @param nameOfImage nameOfImage
 *
 *  @return UIImage
 */
-(UIImage *)imageForImageName:(NSString *)nameOfImage
{
    if(nameOfImage && ![nameOfImage isEqualToString:@""])
    {
        if ([self.currentThemeName isEqualToString:kDefaultTheme])
        {
            return [UIImage imageNamed:nameOfImage];
        }
        else if([self.currentThemeName isEqualToString:kNighttimeTheme])
        {
            NSString *namePathOfImage = [NSString stringWithFormat:@"%@.bundle/%@/%@",_currentThemeName,ImagesDocument,nameOfImage];
            return [UIImage imageNamed:namePathOfImage];
        }
        else
        {
            return [UIImage imageNamed:nameOfImage];
        }
    }
    return [[UIImage alloc]init];
}

/**
 *  register font from bundle
 *
 *  @param fontPath  font path
 *  @param aFontName font name
 *  @param size      size
 *
 *  @return UIFont
 */
-(UIFont *)registFontFromBundle:(NSString *)fontPath fontName:(NSString *)aFontName fontSize:(float)size
{
    NSString *fontFullPath = [_bundlePath stringByAppendingString:fontPath];
    UIFont *font;
    NSData *dataOfFont = [NSData dataWithContentsOfFile:fontFullPath];
    if (dataOfFont)
    {
        CFErrorRef error;
        CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((CFDataRef)dataOfFont);
        CGFontRef fontRef = CGFontCreateWithDataProvider(providerRef);
        if (! CTFontManagerRegisterGraphicsFont(fontRef, &error))
        {
            //if failed ,use default font.
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
            font = [UIFont systemFontOfSize:size];
        }
        else
        {
            font = [UIFont fontWithName:aFontName size:size];
        }
        CFRelease(fontRef);
        CFRelease(providerRef);
        return font;
    }
    else
    {
        return [UIFont systemFontOfSize:size];
    }
}

/**
 *  print all the fonts in your device
 */
- (void)printAllFonts
{
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (NSString *fontFamily in fontFamilies)
    {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamily];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
}

/**
 *  check font is register
 *
 *  @param fontName fontName
 *
 *  @return register or not
 */
- (BOOL)isFontRegisted:(NSString *)fontName
{
    UIFont* aFont = [UIFont fontWithName:fontName size:DefaultFontSize];
    
    BOOL isFontRegisted = (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame
                                     || [aFont.familyName compare:fontName] == NSOrderedSame));
    return isFontRegisted;
}

@end
