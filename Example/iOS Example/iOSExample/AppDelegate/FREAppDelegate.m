//
//  AppDelegate.m
//  iOSExample
//
//  Created by William Boles on 15/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "FREAppDelegate.h"

#import <CoreDataServices/CDSServiceManager.h>

#import "FRETableViewController.h"
#import "FRECollectionViewController.h"

@interface FREAppDelegate ()

@property (nonatomic, strong) UINavigationController *tableNavigationController;
@property (nonatomic, strong) UINavigationController *collectionNavigationController;

@property (nonatomic, strong) FRETableViewController *tableViewController;
@property (nonatomic, strong) FRECollectionViewController *collectionViewController;

@end

@implementation FREAppDelegate

#pragma mark - AppLifeCycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[CDSServiceManager sharedInstance] setupModelURLWithModelName:@"Model"];
    
    /*-------------------*/
    
    self.window.backgroundColor = [UIColor clearColor];
    self.window.clipsToBounds = NO;
    
    [self.window makeKeyAndVisible];
    
    /*-------------------*/
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[CDSServiceManager sharedInstance] saveManagedObjectContext];
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
        [_tabBarController addChildViewController:self.collectionNavigationController];
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

- (UINavigationController *)collectionNavigationController
{
    if (!_collectionNavigationController)
    {
        _collectionNavigationController = [[UINavigationController alloc] initWithRootViewController:self.collectionViewController];
        
        UITabBarItem *collectionNavigationControllerItem = [[UITabBarItem alloc] initWithTitle:@"Collection"
                                                                                         image:[UIImage imageNamed:@"second"]
                                                                                           tag:1];
        
        [_collectionNavigationController setTabBarItem:collectionNavigationControllerItem];
    }
    
    return _collectionNavigationController;
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

- (FRECollectionViewController *)collectionViewController
{
    if (!_collectionViewController)
    {
        _collectionViewController = [[FRECollectionViewController alloc] init];
    }
    
    return _collectionViewController;
}

@end
