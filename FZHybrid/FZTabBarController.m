//
//  FZTabBarController.m
//  FZHybrid
//
//  Created by zzc483 on 2019/1/23.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "FZTabBarController.h"
#import "FZWebViewController.h"
#import "UIColor+Hex.h"
#import "UIImage+Custom.h"

@interface FZTabBarController ()

@end

@implementation FZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTabBarItems];
}

- (void)createTabBarItems
{
    FZWebViewController *homeVC = [FZWebViewController controllerWithType:FZWebViewTypeWK url:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"www/html/index" ofType:@"html"]]];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"tabbar_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_home_HL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    homeVC.tabBarItem = homeTabBarItem;
    
    FZWebViewController *wkVC = [FZWebViewController controllerWithType:FZWebViewTypeWK url:[NSURL URLWithString:@"https://www.baidu.com"]];
    UINavigationController *wkNav = [[UINavigationController alloc] initWithRootViewController:wkVC];
    UITabBarItem *wkTabBarItem = [[UITabBarItem alloc] initWithTitle:@"WK" image:[[UIImage imageNamed:@"tabbar_wk"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_wk_HL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    wkVC.tabBarItem = wkTabBarItem;
    
    FZWebViewController *webVC = [FZWebViewController controllerWithType:FZWebViewTypeWeb url:[NSURL URLWithString:@"https://www.baidu.com"]];
    UINavigationController *webNav = [[UINavigationController alloc] initWithRootViewController:webVC];
    UITabBarItem *webTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Web" image:[[UIImage imageNamed:@"tabbar_web"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_web_HL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    webVC.tabBarItem = webTabBarItem;
    
    [homeVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [wkVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [webVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [homeVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0x2c2c2c], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [wkVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0x2c2c2c], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [webVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0x2c2c2c], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    CGFloat SINGLE_LINE_WIDTH = (1 / [UIScreen mainScreen].scale);
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHex:0xb7ba6b]];
    [[UITabBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor colorWithHex:0xe1e1e1] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, SINGLE_LINE_WIDTH)]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [UITabBar appearance].translucent = NO;
    
    self.viewControllers = @[homeNav, wkNav, webNav];
}

@end
