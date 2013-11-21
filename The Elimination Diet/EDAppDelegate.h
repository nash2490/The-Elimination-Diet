//
//  EDAppDelegate.h
//  The Elimination Diet
//
//  Created by Justin Kahn on 6/8/13.
//  Copyright (c) 2013 Justin Kahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UITabBarController *tabBarController;

@property (nonatomic, strong) UINavigationController *mainNavController;

@end
