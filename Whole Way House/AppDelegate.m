//
//  AppDelegate.m
//  Whole Way House
//
//  Created by Michael Whang on 6/7/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "AppDelegate.h"
#import "ProgramsViewController.h"
#import "SponsorsViewController.h"
#import "AboutViewController.h"
#import "ContactViewController.h"
#import "ContainerViewController.h"
#import "NewsViewController.h"
#import "MediaViewController.h"
#import "VolunteerViewController.h"
#import <Parse/Parse.h>
#import "APIKeys.h"
//#import "Mixpanel.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Initialize Mixpanel analytics
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
/*  
    Set App Delegate to be the delegate for UITabBarControllerDelegate
    Want to use UITabBarControllerDelegate to detect tab selection and enable scroll-to-top on second tap on current tab
    Source 1: http://stackoverflow.com/questions/8336997/storyboard-uitabbarcontroller
    Source 2: http://stackoverflow.com/questions/22392151/tap-tab-bar-to-scroll-to-top-of-uitableviewcontroller
*/
    
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    tabController.delegate = self;
    
    // Initialize Parse integration & analytics
    [Parse setApplicationId:PARSE_APPLICATION_ID
                  clientKey:PARSE_CLIENT_KEY];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Initialize Dynamic Link Library using a singleton
    [LinkLibrary sharedLinkLibrary];
    
    return YES;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    static UIViewController *previousController = nil;
    
    // Using this logic to test if the user is tapping on a tab for the currently opened tab
    // If yes, then trigger a scroll-to-top method
    
    if (previousController == viewController) {
        
        // This one won't be used since I don't have any UITableViewControllers at the moment
        if ([viewController isKindOfClass:[UITableViewController class]])
        {
            [[(UITableViewController *)viewController tableView] setContentOffset:CGPointZero animated:YES];
        }
        // Use this to handle tabs that are embedded within a Navigation Controller
        else if ([viewController isKindOfClass:[UINavigationController class]])
        {
            // Not used
            UINavigationController *nav = (UINavigationController *)viewController;
            if ([nav.visibleViewController isKindOfClass:[UITableViewController class]]) {
                [[(UITableViewController *)nav.visibleViewController tableView] setContentOffset:CGPointZero animated:YES];
            }
            
            // Scroll to top of Latest tab
            else if ([nav.visibleViewController isKindOfClass:[ContainerViewController class]]) {
                ContainerViewController *tabViewController = (ContainerViewController *)nav.visibleViewController;
                if (tabViewController.containerSegmentedControl.selectedSegmentIndex == 0) {
                    for (NewsViewController *childVC in tabViewController.childViewControllers) {
                        if ([childVC isKindOfClass:[NewsViewController class]]) {
                            [childVC performSelector:@selector(scrollToTop)];
                        }
                    }
                } else if (tabViewController.containerSegmentedControl.selectedSegmentIndex == 1) {
                    for (MediaViewController *childVC in tabViewController.childViewControllers) {
                        if ([childVC isKindOfClass:[MediaViewController class]]) {
                            [childVC performSelector:@selector(scrollToTop)];
                        }
                    }
                } else if (tabViewController.containerSegmentedControl.selectedSegmentIndex == 2) {
                    for (VolunteerViewController *childVC in tabViewController.childViewControllers) {
                        if ([childVC isKindOfClass:[VolunteerViewController class]]) {
                            [childVC performSelector:@selector(scrollToTop)];
                        }
                    }
                }
            }
            
            // Scroll to top of Programs tab
            else if ([nav.visibleViewController isKindOfClass:[ProgramsViewController class]]) {
                ProgramsViewController *tabViewController = (ProgramsViewController *)nav.visibleViewController;
                [tabViewController scrollToTop];
            }
            
            // Scroll to top of Sponsors tab
            else if ([nav.visibleViewController isKindOfClass:[SponsorsViewController class]]) {
                SponsorsViewController *tabViewController = (SponsorsViewController *)nav.visibleViewController;
                [tabViewController scrollToTop];
            }
            
            // Scroll to top of Our Story tab
            else if ([nav.visibleViewController isKindOfClass:[AboutViewController class]]) {
                AboutViewController *tabViewController = (AboutViewController *)nav.visibleViewController;
                [tabViewController scrollToTop];
            }
            
            // Scroll to top of Contact tab
            else if ([nav.visibleViewController isKindOfClass:[ContactViewController class]]) {
                ContactViewController *tabViewController = (ContactViewController *)nav.visibleViewController;
                [tabViewController scrollToTop];
            }
            
        }
        // Use the following to handle tabs that are using plain UIViewControllers
        else if ([viewController isKindOfClass:[AboutViewController class]]) {
            AboutViewController *tabViewController = (AboutViewController *)viewController;
            [tabViewController scrollToTop];
        }
        // Use the following to handle tabs that are using plain UIViewControllers
        else if ([viewController isKindOfClass:[ContactViewController class]]) {
            ContactViewController *tabViewController = (ContactViewController *)viewController;
            [tabViewController scrollToTop];
        }
    }
    
    previousController = viewController;
}

//- (void)tabBarController:(UITabBarController *)tabBarController
// didSelectViewController:(UIViewController *)viewController
//{
//    static UIViewController *previousController = nil;
//    if (previousController == viewController) {
//        // the same tab was tapped a second time
//        if ([viewController respondsToSelector:@selector(scrollToTop)]) {
//            [viewController scrollToTop];
//        }
//    }
//    previousController = viewController;
//}

#pragma mark - Default Methods
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
