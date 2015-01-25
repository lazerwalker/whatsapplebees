//
//  AppDelegate.m
//  WhatsApplebees
//
//  Created by Michael Walker on 3/6/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "AppDelegate.h"
#import "ListViewController.h"

#import <Parse/Parse.h>
#import "UIImage+ImageWithColor.h"
#import <IntentKit/INKActivityViewController.h>
#import <CocoaPods-Keys/WhatsApplebeesKeys.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    WhatsApplebeesKeys *keys = [[WhatsApplebeesKeys alloc] init];
    [Parse setApplicationId:keys.parseAppID
                  clientKey:keys.parseClientKey];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    ListViewController *listController = [[ListViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:listController];

    self.window.rootViewController = navController;
    return YES;
}

@end
