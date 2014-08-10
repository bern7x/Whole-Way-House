//
//  ProgramsViewController.m
//  WWH
//
//  Created by Michael Whang on 6/17/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "ProgramsViewController.h"
#import "DSWebViewController.h"
#import "TintedImageView.h"

@interface ProgramsViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *familyOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *familyVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *gamesNightOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *gamesNightVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *petTherapyOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *petTherapyVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *breakfastOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *breakfastVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *haircutOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *haircutVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *communityOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *communityVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *birthdaysOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *birthdaysVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *sundaySandwichesOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *sundaySandwichesVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *artsOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *artsVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *openOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *openVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *workshopsOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *workshopsVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *makingHomeOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *makingHomeVolunteerButton;
@property (strong, nonatomic) IBOutlet UIView *canteenOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *canteenVolunteerButton;

@end

@implementation ProgramsViewController

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
    
    // Mixpanel Analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Programs"];
    [mixpanel flush];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

#define VOLUNTEER_FIRST_TIME_QUESTIONNAIRE @"https://docs.google.com/forms/d/1JPFdFaToJ6U1uOYIeyJ7olrzzDBRr3ZQNxQEdWugAK8/viewform"
#define VOLUNTEER_SIGN_UP_FORM @"http://doodle.com/ffth9nf6r427ab9f"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *url = (NSString *)sender;
    if ([segue.identifier isEqualToString:@"toWebViewControllerSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[DSWebViewController class]]) {
            DSWebViewController *nextViewController = (DSWebViewController *)segue.destinationViewController;
            nextViewController.url = url;
        }
    }
}

#pragma mark - IB Actions

- (IBAction)volunteerButtonPressed:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Volunteer Sign-up Form", @"First-Time Questionnaire", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (IBAction)volunteerBarButtonItemPressed:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Volunteer Sign-up Form", @"First-Time Questionnaire", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (IBAction)familyToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.familyOverlayView];
    self.familyVolunteerButton.hidden = !self.familyVolunteerButton.hidden;
}

- (IBAction)gamesNightToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.gamesNightOverlayView];
    self.gamesNightVolunteerButton.hidden = !self.gamesNightVolunteerButton.hidden;
}

- (IBAction)petTherapyToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.petTherapyOverlayView];
    self.petTherapyVolunteerButton.hidden = !self.petTherapyVolunteerButton.hidden;
}

- (IBAction)breakfastToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.breakfastOverlayView];
    self.breakfastVolunteerButton.hidden = !self.breakfastVolunteerButton.hidden;
}

- (IBAction)haircutToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.haircutOverlayView];
    self.haircutVolunteerButton.hidden = !self.haircutVolunteerButton.hidden;
}

- (IBAction)communityToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.communityOverlayView];
    self.communityVolunteerButton.hidden = !self.communityVolunteerButton.hidden;
}

- (IBAction)birthdaysToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.birthdaysOverlayView];
    self.birthdaysVolunteerButton.hidden = !self.birthdaysVolunteerButton.hidden;
}

- (IBAction)sundaySandwichesToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.sundaySandwichesOverlayView];
    self.sundaySandwichesVolunteerButton.hidden = !self.sundaySandwichesVolunteerButton.hidden;
}

- (IBAction)artsToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.artsOverlayView];
    self.artsVolunteerButton.hidden = !self.artsVolunteerButton.hidden;
}

- (IBAction)openToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.openOverlayView];
    self.openVolunteerButton.hidden = !self.openVolunteerButton.hidden;
}

- (IBAction)workshopsToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.workshopsOverlayView];
    self.workshopsVolunteerButton.hidden = !self.workshopsVolunteerButton.hidden;
}

- (IBAction)makingHomeToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.makingHomeOverlayView];
    self.makingHomeVolunteerButton.hidden = !self.makingHomeVolunteerButton.hidden;
}

- (IBAction)canteenToggleButtonPressed:(UIButton *)sender
{
    [self toggleOverlayView:self.canteenOverlayView];
    self.canteenVolunteerButton.hidden = !self.canteenVolunteerButton.hidden;
}

#pragma mark - Helper Methods

// Animation to fade the text overlay view in and out
- (void)toggleOverlayView:(UIView *)view
{
    if (view.alpha == 1.0) {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             view.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             // Other
                         }
         ];
    } else {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             view.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             // Other
                         }
         ];
    }
}

// Scroll-to-top (triggered by TabBarController)
- (void)scrollToTop
{
    // Source: http://stackoverflow.com/questions/9450302/tell-uiscrollview-to-scroll-to-the-top?rq=1
    
    [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self performSegueWithIdentifier:@"toWebViewControllerSegue" sender:VOLUNTEER_SIGN_UP_FORM];
                    NSLog(@"Open in Safari button pressed");
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"toWebViewControllerSegue" sender:VOLUNTEER_FIRST_TIME_QUESTIONNAIRE];
                    NSLog(@"Open First-time Questionnaire button pressed");
                    break;
                    //                case 1:
                    //                    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
                    //                    NSLog(@"Cancel button pressed");
                    //                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}




@end
