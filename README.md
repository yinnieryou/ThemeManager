# ThemeManager
This repo is about how to change a theme in iOS.

It's easy to use.
The APIs are below:

 *  @brief  notification name(before change theme it will post this notifiation)

extern NSString *const kThemeManagerShouldChangeTheme;

 *  @brief sharedManager
 *
 *  @return instance of ThemeManager

+(instancetype)sharedManager;

 *  @brief  name of current theme

@property (nonatomic, strong) NSString *currentThemeName;

 *  @brief  change the theme
 *
 *  @param themeName which theme would you like to change
 *  @param isNotify  post a notification or not
 *  
-(void)changeTheme:(NSString *)themeName shouldNotify:(BOOL)isNotify;

 *  @brief  get the font from the plist file by the key
 *
 *  @param keyOfFont keyOfFont
 *
 *  @return UIFont
 
-(UIFont *)fontForKey:(NSString *)keyOfFont;


 *  @brief  get the color by key
 *
 *  @param keyOfColor keyOfColor
 *
 *  @return UIColor

-(UIColor *)colorForKey:(NSString *)keyOfColor;


 *  @brief  get the image by the name of image
 *
 *  @param nameOfImage nameOfImage
 *
 *  @return UIImage
 
-(UIImage *)imageForImageName:(NSString *)nameOfImage;

If you would like to change the theme just call "changeTheme: shouldNotify:".

But don't forget to add your own macro into the "ThemeManagerMacro.h", and make sure your bundle files had added what you define in macro.
