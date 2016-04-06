//
//  AppDelegate.m
//  iOSExample
//
//  Created by William Boles on 15/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "FREAppDelegate.h"

#import <CoreDataServices/CoreDataServices-Swift.h>

#import "FRETableViewController.h"

@interface FREAppDelegate ()

@property (nonatomic, strong) UINavigationController *tableNavigationController;

@property (nonatomic, strong) FRETableViewController *tableViewController;

@end

@implementation FREAppDelegate

#pragma mark - AppLifeCycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[ServiceManager sharedInstance] setupModelURLWithModelName:@"Model"];
    
    /*-------------------*/
    
    self.window.backgroundColor = [UIColor clearColor];
    self.window.clipsToBounds = NO;
    
    [self.window makeKeyAndVisible];
    
    /*-------------------*/
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[ServiceManager sharedInstance] saveMainManagedObjectContext];
}

#pragma mark - Window

- (UIWindow *)window
{
    if (!_window)
    {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.rootViewController = self.tabBarController;
    }
    
    return _window;
}

#pragma mark - Navigation

- (UITabBarController *)tabBarController
{
    if (!_tabBarController)
    {
        _tabBarController = [[UITabBarController alloc] init];
        
        [_tabBarController addChildViewController:self.tableNavigationController];

    }
    
    return _tabBarController;
}

- (UINavigationController *)tableNavigationController
{
    if (!_tableNavigationController)
    {
        _tableNavigationController = [[UINavigationController alloc] initWithRootViewController:self.tableViewController];
        
        UITabBarItem *tableNavigationControllerItem = [[UITabBarItem alloc] initWithTitle:@"Table"
                                                                                    image:[UIImage imageNamed:@"first"]
                                                                                      tag:0];
        
        [_tableNavigationController setTabBarItem:tableNavigationControllerItem];
    }
    
    return _tableNavigationController;
}

#pragma mark - ViewController

- (FRETableViewController *)tableViewController
{
    if (!_tableViewController)
    {
        _tableViewController = [[FRETableViewController alloc] init];
    }
    
    return _tableViewController;
}

@end
