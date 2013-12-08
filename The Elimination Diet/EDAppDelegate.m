//
//  EDAppDelegate.m
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import "EDAppDelegate.h"

#import "EDMainMenuVC.h"

#import "EDSelectMealsViewController.h"

#import "EDTypeTableViewController.h"
#import "EDIngredientTableViewController.h"
#import "EDMealTableViewController.h"

#import "EDEatenMealTableViewController.h"

#import "EDMapViewController.h"
#import "EDCreateRestaurantViewController.h"


@implementation EDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    
    UIColor *brownNavBarColor = [[UIColor alloc] initWithRed:0.78f green:0.56f blue:0.06f alpha:1.0f];
    
    [self.mainNavController.navigationBar setTintColor:brownNavBarColor];
    
    /*
    EDTypeTableViewController *typeTable = [[EDTypeTableViewController alloc] initWithNibName:nil bundle:nil];
    EDIngredientTableViewController *ingredTable = [[EDIngredientTableViewController alloc] initWithNibName:nil bundle:nil];
    EDMealTableViewController *mealTable = [[EDMealTableViewController alloc] initWithNibName:nil bundle:nil];
    
    //EDEliminatedTypeTableViewController *elimTypeTable = [[EDEliminatedTypeTableViewController alloc] init];
    //EDEliminatedIngredientTableViewController *elimIngrTable = [[EDEliminatedIngredientTableViewController alloc] initWithNibName:nil bundle:nil];
    EDEatenMealTableViewController *eatenMealTable = [[EDEatenMealTableViewController alloc] initWithNibName:nil bundle:nil];
    
    EDTodayViewController *todayView = [[EDTodayViewController alloc] initWithNibName:nil bundle:nil];
    EDSelectMealsViewController *selectMealsView = [[EDSelectMealsViewController alloc] initWithNibName:nil bundle:nil];
    
    EDCreateRestaurantViewController *createRestaurantView = [[EDCreateRestaurantViewController alloc] initWithNibName:nil bundle:nil];
    
    self.mainNavController = [[UINavigationController alloc] initWithRootViewController:todayView];
    
    //UINavigationController *mapNav = [[UINavigationController alloc] initWithRootViewController:createRestaurantView];
    
    //[self.tabBarController setViewControllers:@[self.mainNavController, mapNav]];
    
    */
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    UITabBarController *recordViewController = [mainStoryboard instantiateInitialViewController];
//    //UIViewController *recentVC= [mainStoryboard instantiateViewControllerWithIdentifier:@"hello"];
//   // [self.tabBarController setViewControllers:@[recentVC]];
//
//    
//    //EDEatenMealTableViewController *eatenMealTable = [[EDEatenMealTableViewController alloc] initWithNibName:nil bundle:nil];
//
//    
//    self.mainNavController = [[UINavigationController alloc] initWithRootViewController:todayView];

    
    //[self.window setRootViewController:recordViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    if ([urls count]) {
       // NSURL *documentsFolder = [urls objectAtIndex:0];
        //NSString *filePath = [[documentsFolder path] stringByAppendingString:@"FoodLogData.archive"];
        
        //EDData *data = [EDData mheddata];
        
        //BOOL archiveSuccess = [NSKeyedArchiver archiveRootObject:data toFile:filePath];
       // NSLog(@"Archive Success = %d", archiveSuccess);
    }
     
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
