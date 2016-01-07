//
//  AppDelegate.m
//  Music Feed
//
//  Created by Luke sammut on 6/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "AppDelegate.h"
#import "MusicFeedViewController.h"
#import "TripleJViewController.h"
#import <MagicalRecord/MagicalRecord.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Set up the navigation including the tab bar and nav controllers
    [self setupNavigation];
    
    // Magical record setting up the Core Data stack for use
    [MagicalRecord setupCoreDataStack];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//sets the navigation up for the application
-(void) setupNavigation
{
    //the tab bar music feeds (triple j and own music)
    MusicFeedViewController *musicFeedVC = [[MusicFeedViewController alloc] init];
    TripleJViewController *tripleJVC = [[TripleJViewController alloc]init];
    
    // Tab Bar controller
    // Will contain two navigation controllers
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    // Navigation Controllers
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:musicFeedVC];
    UINavigationController *tripleJNavController = [[UINavigationController alloc]initWithRootViewController:tripleJVC];
    
    // UI Images to be set as the tab bar icons for both navigation controllers that will reside in it
    tripleJNavController.tabBarItem.image = [UIImage imageNamed:@"TripleJ-tapped"];
    navController.tabBarItem.image = [UIImage imageNamed:@"Music-tapped"];
    
    //Add the nav controllers to the Tab Bar Controller
    [tabBarController addChildViewController:navController];
    [tabBarController addChildViewController:tripleJNavController];
    
    // Set the window to initially show the tab bar controller
    self.window.rootViewController = tabBarController;
}

@end
