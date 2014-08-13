//
//  AboutViewController.m
//  Whole Way House
//
//  Created by Michael Whang on 6/7/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "AboutViewController.h"
#import "UIImageViewAligned.h"

@interface AboutViewController () <UIScrollViewDelegate>

// IB Outlets
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *missionScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *wwhLogoImageView;
@property (strong, nonatomic) IBOutlet UIWebView *youtubeWebView;
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
@property (strong, nonatomic) IBOutlet UIPageControl *missionPageControl;
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
    self.missionScrollView.delegate = self;
    
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
    
    // Use to update page control for missionScrollView
    if (scrollView == self.missionScrollView) {
        self.missionPageControl.currentPage = floorf(scrollView.contentOffset.x/320);
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)topImageButtonPressed:(UIButton *)sender
{
    [self randomTopImage:self.imageNumber];
}

#pragma mark - Helper Methods

// Scroll-to-top (triggered by TabBarController)
- (void)scrollToTop
{
    // Source: http://stackoverflow.com/questions/9450302/tell-uiscrollview-to-scroll-to-the-top?rq=1
    
    [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
}


@end
