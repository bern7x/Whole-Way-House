//
//  ContainerViewController.m
//  WWH
//
//  Created by Michael Whang on 8/16/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "ContainerViewController.h"
#import "ShareSetting.h"

@interface ContainerViewController ()

@property (weak, nonatomic) IBOutlet UIView *newsContainerView;
@property (weak, nonatomic) IBOutlet UIView *eventsContainerView;
@property (weak, nonatomic) IBOutlet UIView *volunteerContainerView;
@property (strong, nonatomic) ShareSetting *shareSettings;
@property (strong, nonatomic) IBOutlet UISegmentedControl *containerSegmentedControl;

@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shareSettings = [ShareSetting sharedSettings];
    self.shareSettings.currentView = @"News";
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsTapped) name:@"newsTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsTapped) name:@"eventsTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volunteersTapped) name:@"volunteersTapped" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newsTapped" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eventsTapped" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"volunteersTapped" object:nil];
}

- (void)newsTapped
{
    if ([self.shareSettings.currentView isEqualToString:@"News"]) {
        // do nothing since the user is already in the Menu view
    } else {
        // shift the menu view into the screen and shift main view off screen
        [UIView animateWithDuration:0.3 animations:^{
            self.newsContainerView.frame = CGRectMake(0,
                                                      self.newsContainerView.frame.origin.y,
                                                      self.newsContainerView.frame.size.width,
                                                      self.newsContainerView.frame.size.height);
            self.eventsContainerView.frame = CGRectMake(320,
                                                        self.eventsContainerView.frame.origin.y,
                                                        self.eventsContainerView.frame.size.width,
                                                        self.eventsContainerView.frame.size.height);
            self.volunteerContainerView.frame = CGRectMake(640,
                                                           self.volunteerContainerView.frame.origin.y,
                                                           self.volunteerContainerView.frame.size.width,
                                                           self.volunteerContainerView.frame.size.height);
        }];
    }
    self.shareSettings.currentView = @"News";
}

- (void)eventsTapped
{
    if ([self.shareSettings.currentView isEqualToString:@"Events"]) {
        // do nothing since the user is already in the Main view
    } else {
        // shift the menu view into the screen and shift main view off screen
        [UIView animateWithDuration:0.3 animations:^{
            self.newsContainerView.frame = CGRectMake(-320,
                                                      self.newsContainerView.frame.origin.y,
                                                      self.newsContainerView.frame.size.width,
                                                      self.newsContainerView.frame.size.height);
            self.eventsContainerView.frame = CGRectMake(0,
                                                        self.eventsContainerView.frame.origin.y,
                                                        self.eventsContainerView.frame.size.width,
                                                        self.eventsContainerView.frame.size.height);
            self.volunteerContainerView.frame = CGRectMake(320,
                                                           self.volunteerContainerView.frame.origin.y,
                                                           self.volunteerContainerView.frame.size.width,
                                                           self.volunteerContainerView.frame.size.height);
        }];
    }
    
    self.shareSettings.currentView = @"Events";
}

- (void)volunteersTapped
{
    if ([self.shareSettings.currentView isEqualToString:@"Volunteers"]) {
        // do nothing since the user is already in the Profile view
    } else {
        // shift the menu view into the screen and shift main view off screen
        [UIView animateWithDuration:0.3 animations:^{
            self.newsContainerView.frame = CGRectMake(-640,
                                                      self.newsContainerView.frame.origin.y,
                                                      self.newsContainerView.frame.size.width,
                                                      self.newsContainerView.frame.size.height);
            self.eventsContainerView.frame = CGRectMake(-320,
                                                        self.eventsContainerView.frame.origin.y,
                                                        self.eventsContainerView.frame.size.width,
                                                        self.eventsContainerView.frame.size.height);
            self.volunteerContainerView.frame = CGRectMake(0,
                                                           self.volunteerContainerView.frame.origin.y,
                                                           self.volunteerContainerView.frame.size.width,
                                                           self.volunteerContainerView.frame.size.height);
        }];
    }
    
    self.shareSettings.currentView = @"Volunteers";
}

#pragma mark - IB Actions

- (IBAction)containerSegmentedControlPressed:(UISegmentedControl *)sender
{
    if (self.containerSegmentedControl.selectedSegmentIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newsTapped" object:nil];
    } else if (self.containerSegmentedControl.selectedSegmentIndex == 1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"eventsTapped" object:nil];
    } else if (self.containerSegmentedControl.selectedSegmentIndex == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"volunteersTapped" object:nil];
    }
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
