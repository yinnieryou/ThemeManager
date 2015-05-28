//
//  ViewController.m
//  ThemeManagerExample
//
//  Created by sosobtc on 15/5/28.
//  Copyright (c) 2015年 yinnieryou. All rights reserved.
//

#import "ViewController.h"

#import "ThemeManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeWillChange) name:kThemeManagerShouldChangeTheme object:nil];
    [self themeWillChange];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeTheme:(UIButton *)sender {
    if (sender.tag == 1000) {
        [[ThemeManager sharedManager]changeTheme:kDaytimeTheme shouldNotify:YES];
    }else if (sender.tag == 1001){
        [[ThemeManager sharedManager]changeTheme:kNighttimeTheme shouldNotify:YES];
    }
}

-(void)themeWillChange
{
    [self.button0 setTitleColor:[[ThemeManager sharedManager] colorForKey:ButtonColor] forState:UIControlStateNormal];
    [self.button1 setTitleColor:[[ThemeManager sharedManager] colorForKey:ButtonColor] forState:UIControlStateNormal];
    
    [self.button0.titleLabel setFont:[[ThemeManager sharedManager] fontForKey:ButtonFont]];
    [self.button1.titleLabel setFont:[[ThemeManager sharedManager] fontForKey:ButtonFont]];
    
    [self.button1 setImage:[[ThemeManager sharedManager] imageForImageName:TestImage] forState:UIControlStateNormal];
    [self.button0 setImage:[[ThemeManager sharedManager] imageForImageName:TestImage] forState:UIControlStateNormal];
}

@end
