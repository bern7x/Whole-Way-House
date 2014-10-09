//
//  ContainerViewController.m
//  WWH
//
//  Created by Michael Whang on 8/16/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "ContainerViewController.h"
#import "ShareSetting.h"
#import "NewsViewController.h"
#import "MediaViewController.h"
#import "VolunteerViewController.h"

@interface ContainerViewController ()

@property (strong, nonatomic) ShareSetting *shareSettings;

@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shareSettings = [ShareSetting sharedSettings];
    self.shareSettings.currentView = @"News";
    
    [self scrollToTopCleanUp];
}

- (void)scrollToTopCleanUp
{
    // Enabling scroll-to-top via status bar tap
    // This clean-up routine is necessary due to multiple scrollviews being present on the screen at the same time
    // This routine explains to the view controller which subview should scroll-to-top when user taps status bar
    ContainerViewController *containerVC = self;
    if (self.containerSegmentedControl.selectedSegmentIndex == 0) {
        for (NewsViewController *childVC in containerVC.childViewControllers) {
            if ([childVC isKindOfClass:[NewsViewController class]]) {
                [childVC.tableView setScrollsToTop:YES];
            }
        }
        for (MediaViewController *childVC in containerVC.childViewControllers) {
            if ([childVC isKindOfClass:[MediaViewController class]]) {
                [childVC.tableView setScrollsToTop:NO];
            }
        }
        for (VolunteerViewController *childVC in containerVC.childViewControllers) {
            if ([childVC isKindOfClass:[VolunteerViewController class]]) {
                [childVC.scrollView setScrollsToTop:NO];
            }
        }
    }
    if (self.containerSegmentedControl.selectedSegmentIndex == 1) {
        for (NewsViewController *childVC in containerVC.childViewControllers) {
            if ([childVC isKindOfClass:[NewsViewController class]]) {
                [childVC.tableView setScrollsToTop:NO];
            }
        }
        for (MediaViewController *childVC in containerVC.childViewControllers) {
            if ([childVC isKindOfClass:[MediaViewController class]]) {
                [childVC.tableView setScrollsToTop:YES];
            }
        }
        for (VolunteerViewController *childVC in containerVC.childViewControllers) {
            if ([childVC isKindOfClass:[VolunteerViewController class]]) {
                [childVC.scrollView setScrollsToTop:NO];
            }
        }
    }
    if (self.containerSegmentedControl.selectedSegmentIndex == 2) {
        for (NewsViewController *childVC in containerVC.childViewControllers) {
            if ([childVC isKindOfClass:[NewsViewController class]]) {
                [childVC.tableView setScrollsToTop:NO];
            }
        }
        for (MediaViewController *childVC in containerVC.childViewControllers) {
            if ([childVC isKindOfClass:[MediaViewController class]]) {
                [childVC.tableView setScrollsToTop:NO];
            }
        }
        for (VolunteerViewController *childVC in containerVC.childViewControllers) {
            if ([childVC isKindOfClass:[VolunteerViewController class]]) {
                [childVC.scrollView setScrollsToTop:YES];
            }
        }
    }
}

/*
// Scroll to top of Latest tab
else if ([nav.visibleViewController isKindOfClass:[ContainerViewController class]]) {
    ContainerViewController *tabViewController = (ContainerViewController *)nav.visibleViewController;
    if (tabViewController.containerSegmentedControl.selectedSegmentIndex == 0) {
        for (NewsViewController *childVC in tabViewController.childViewControllers) {
            if ([childVC isKindOfClass:[NewsViewController class]]) {
                [childVC performSelector:@selector(scrollToTop)];
*/

/*
    Using tab bar navigation, when user returns to the "Latest" tab, the app always reverts back to the initial default position of the container
    views. Therefore, need to manually set the positions of the container views according to the current value of self.shareSettings.currentView 
    or the segmented control.
 */

//- (void)viewWillAppear:(BOOL)animated
//{
//    NSLog(@"viewWillAppear");
//    NSLog(@"%f", self.mediaContainerView.frame.origin.x);
//    if ((self.containerSegmentedControl.selectedSegmentIndex == 1) && (self.mediaContainerView.frame.origin.x != 0)) {
//        NSLog(@"Need to shift views");
//        [self.view bringSubviewToFront:self.mediaContainerView];
//        self.mediaContainerView.frame = CGRectMake(0,
//                                                   self.mediaContainerView.frame.origin.y,
//                                                   self.mediaContainerView.frame.size.width,
//                                                   self.mediaContainerView.frame.size.height);
//    }
//}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsTapped) name:@"newsTapped" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaTapped) name:@"mediaTapped" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volunteersTapped) name:@"volunteersTapped" object:nil];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newsTapped" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mediaTapped" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"volunteersTapped" object:nil];
//}
//
//- (void)newsTapped
//{
//    if ([self.shareSettings.currentView isEqualToString:@"News"]) {
//        // do nothing since the user is already in the Menu view
//    } else {
//        // shift the menu view into the screen and shift main view off screen
//        [UIView animateWithDuration:0.3 animations:^{
//            self.newsContainerView.frame = CGRectMake(0,
//                                                      self.newsContainerView.frame.origin.y,
//                                                      self.newsContainerView.frame.size.width,
//                                                      self.newsContainerView.frame.size.height);
//            self.mediaContainerView.frame = CGRectMake(320,
//                                                        self.mediaContainerView.frame.origin.y,
//                                                        self.mediaContainerView.frame.size.width,
//                                                        self.mediaContainerView.frame.size.height);
//            self.volunteerContainerView.frame = CGRectMake(640,
//                                                           self.volunteerContainerView.frame.origin.y,
//                                                           self.volunteerContainerView.frame.size.width,
//                                                           self.volunteerContainerView.frame.size.height);
//        }];
//    }
//    self.shareSettings.currentView = @"News";
//}
//
//- (void)mediaTapped
//{
//    if ([self.shareSettings.currentView isEqualToString:@"Media"]) {
//        // do nothing since the user is already in the Media view
//        
//    } else {
//        // shift the menu view into the screen and shift main view off screen
//        [UIView animateWithDuration:0.3 animations:^{
//            self.newsContainerView.frame = CGRectMake(-320,
//                                                      self.newsContainerView.frame.origin.y,
//                                                      self.newsContainerView.frame.size.width,
//                                                      self.newsContainerView.frame.size.height);
//            self.mediaContainerView.frame = CGRectMake(0,
//                                                        self.mediaContainerView.frame.origin.y,
//                                                        self.mediaContainerView.frame.size.width,
//                                                        self.mediaContainerView.frame.size.height);
//            self.volunteerContainerView.frame = CGRectMake(320,
//                                                           self.volunteerContainerView.frame.origin.y,
//                                                           self.volunteerContainerView.frame.size.width,
//                                                           self.volunteerContainerView.frame.size.height);
//        }];
//    }
//    
//    self.shareSettings.currentView = @"Media";
//}
//
//- (void)volunteersTapped
//{
//    if ([self.shareSettings.currentView isEqualToString:@"Volunteers"]) {
//        // do nothing since the user is already in the Profile view
//    } else {
//        // shift the menu view into the screen and shift main view off screen
//        [UIView animateWithDuration:0.3 animations:^{
//            self.newsContainerView.frame = CGRectMake(-640,
//                                                      self.newsContainerView.frame.origin.y,
//                                                      self.newsContainerView.frame.size.width,
//                                                      self.newsContainerView.frame.size.height);
//            self.mediaContainerView.frame = CGRectMake(-320,
//                                                        self.mediaContainerView.frame.origin.y,
//                                                        self.mediaContainerView.frame.size.width,
//                                                        self.mediaContainerView.frame.size.height);
//            self.volunteerContainerView.frame = CGRectMake(0,
//                                                           self.volunteerContainerView.frame.origin.y,
//                                                           self.volunteerContainerView.frame.size.width,
//                                                           self.volunteerContainerView.frame.size.height);
//        }];
//    }
//    
//    self.shareSettings.currentView = @"Volunteers";
//}

#pragma mark - IB Actions

//- (IBAction)containerSegmentedControlPressed:(UISegmentedControl *)sender
//{
//    if (self.containerSegmentedControl.selectedSegmentIndex == 0) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"newsTapped" object:nil];
//    } else if (self.containerSegmentedControl.selectedSegmentIndex == 1){
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"mediaTapped" object:nil];
//    } else if (self.containerSegmentedControl.selectedSegmentIndex == 2) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"volunteersTapped" object:nil];
//    }
//}

- (IBAction)containerSegmentedControlPressed:(UISegmentedControl *)sender
{
    if (self.containerSegmentedControl.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:self.newsContainerView];
    } else if (self.containerSegmentedControl.selectedSegmentIndex == 1){
        [self.view bringSubviewToFront:self.mediaContainerView];
    } else if (self.containerSegmentedControl.selectedSegmentIndex == 2) {
        [self.view bringSubviewToFront:self.volunteerContainerView];
    }
    [self scrollToTopCleanUp];
}

- (IBAction)swipeRightGesture:(UISwipeGestureRecognizer *)sender
{
    if (self.containerSegmentedControl.selectedSegmentIndex == 0) {
        // Do nothing
    } else if (self.containerSegmentedControl.selectedSegmentIndex == 1) {
        [self.view bringSubviewToFront:self.newsContainerView];
        [self.containerSegmentedControl setSelectedSegmentIndex:0];
    } else if (self.containerSegmentedControl.selectedSegmentIndex == 2) {
        [self.view bringSubviewToFront:self.mediaContainerView];
        [self.containerSegmentedControl setSelectedSegmentIndex:1];
    }
    [self scrollToTopCleanUp];
}


- (IBAction)swipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    if (self.containerSegmentedControl.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:self.mediaContainerView];
        [self.containerSegmentedControl setSelectedSegmentIndex:1];
    } else if (self.containerSegmentedControl.selectedSegmentIndex == 1){
        [self.view bringSubviewToFront:self.volunteerContainerView];
        [self.containerSegmentedControl setSelectedSegmentIndex:2];
    } else if (self.containerSegmentedControl.selectedSegmentIndex == 2) {
        // Do nothing
    }
    [self scrollToTopCleanUp];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
