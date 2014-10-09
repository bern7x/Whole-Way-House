//
//  AboutViewController.m
//  Whole Way House
//
//  Created by Michael Whang on 6/7/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "AboutViewController.h"
#import "UIImageViewAligned.h"
#import "DSWebViewController.h"

@interface AboutViewController () <UIScrollViewDelegate, UIActionSheetDelegate>

// IB Outlets
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *wwhLogoImageView;
@property (strong, nonatomic) IBOutlet UIWebView *youtubeWebView;
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
@property (strong, nonatomic) IBOutlet UIWebView *breakfastTelevisionWebView;

// Instance Variables
@property (strong, nonatomic) UIRefreshControl *aboutRefreshControl;
@property (nonatomic) int imageNumber;
@property (strong, nonatomic) LinkLibrary *links;

@end

@implementation AboutViewController

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
    
    self.scrollView.delegate = self;
    
    self.wwhLogoImageView.layer.cornerRadius = 50.0;
    self.wwhLogoImageView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    
    // Set random image for topScrollView
    self.imageNumber = 1;
    
    // Initialize Link Library
    self.links = [LinkLibrary sharedLinkLibrary];
    
    // Pull to Refresh
    UIRefreshControl *refreshControl =[[UIRefreshControl alloc] init];
    self.aboutRefreshControl = refreshControl;
    [self.aboutRefreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.aboutRefreshControl];
    [self.scrollView sendSubviewToBack:self.aboutRefreshControl];
    
    // Embedded YouTube videos
    NSURL *url = [NSURL URLWithString:self.links.linkDictionary[@"amazing"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.youtubeWebView loadRequest:request];
    
    NSURL *url2 = [NSURL URLWithString:self.links.linkDictionary[@"interview"]];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
    [self.breakfastTelevisionWebView loadRequest:request2];
    
    // Mixpanel Analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Our Story"];
    [mixpanel flush];
    
    // Scroll-to-top
    [self.scrollView setScrollsToTop:YES];
    [self.topScrollView setScrollsToTop:NO];
    [self.youtubeWebView.scrollView setScrollsToTop:NO];
    [self.breakfastTelevisionWebView.scrollView setScrollsToTop:NO];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl
{
//    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MMM d, h:mm a"];
//    NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
//    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
    
    [self randomTopImage:self.imageNumber];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Use for parallax effect in topScrollView
    CGPoint offset = self.topScrollView.contentOffset;
    offset.y = self.scrollView.contentOffset.y * 0.2;
    [self.topScrollView setContentOffset:offset];
}

#define NUMBER_OF_WWH_PHOTOS 5

- (void)randomTopImage:(int)currentNumber
{
    do {
        self.imageNumber = (arc4random() % NUMBER_OF_WWH_PHOTOS) + 1;
    } while (self.imageNumber == currentNumber);
    
    NSString *imageRef = [NSString stringWithFormat:@"%d", self.imageNumber];
    
    UIImage *newImage = [UIImage imageNamed:[NSString stringWithFormat:@"wwh%@", imageRef]];
    
    [UIView transitionWithView:self.topImageView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.topImageView.image = newImage;
                    } completion:nil];
    
    //NSLog(@"Image set to #%@", imageRef);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toWebViewControllerSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[DSWebViewController class]]) {
            DSWebViewController *nextViewController = (DSWebViewController *)segue.destinationViewController;
            nextViewController.url = sender;
        }
    }
}

#pragma mark - Helper Methods

- (IBAction)topImageButtonPressed:(UIButton *)sender
{
    [self randomTopImage:self.imageNumber];
}

// Scroll-to-top (triggered by TabBarController)
- (void)scrollToTop
{
    // Source: http://stackoverflow.com/questions/9450302/tell-uiscrollview-to-scroll-to-the-top?rq=1
    
    [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
}

#pragma mark - IB Actions

- (IBAction)donateBarButtonItemPressed:(UIBarButtonItem *)sender
{
    NSString *donate = self.links.linkDictionary[@"donate"];
    [self performSegueWithIdentifier:@"toWebViewControllerSegue" sender:donate];
}

- (IBAction)volunteerBarButtonItemPressed:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Volunteer Sign-up Form", @"First-Time Questionnaire", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Load Dynamic Link Library
    LinkLibrary *links = [LinkLibrary sharedLinkLibrary];
    NSString *signup = links.linkDictionary[@"signup"];
    NSString *questionnaire = links.linkDictionary[@"questionnaire"];
    
    switch (actionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self performSegueWithIdentifier:@"toWebViewControllerSegue" sender:signup];
                    //NSLog(@"Volunteer sign-up button pressed");
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"toWebViewControllerSegue" sender:questionnaire];
                    //NSLog(@"Open First-time Questionnaire button pressed");
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


/*

#pragma - ScrollsToTop Troubleshooting Code
// Source: http://stackoverflow.com/questions/8527801/how-to-find-out-which-other-uiscrollview-interferes-with-scrollstotop
 
- (IBAction)findProblemsButtonPressed:(UIBarButtonItem *)sender
{
    [self findMisbehavingScrollViews];
}

- (void)findMisbehavingScrollViews
{
    //UIView *view = [[UIApplication sharedApplication] keyWindow];
    UIView *view = self.view;
    [self findMisbehavingScrollViewsIn:view];
}

- (void)findMisbehavingScrollViewsIn:(UIView *)view
{
    if ([view isKindOfClass:[UIScrollView class]])
    {
        NSLog(@"Found UIScrollView: %@", view);
        if ([(UIScrollView *)view scrollsToTop])
        {
            NSLog(@"scrollsToTop = YES!");
        }
    }
    for (UIView *subview in [view subviews])
    {
        [self findMisbehavingScrollViewsIn:subview];
    }
}

*/

@end
