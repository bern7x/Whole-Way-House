//
//  TwitterViewController.m
//  WWH
//
//  Created by Michael Whang on 6/20/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "TwitterViewController.h"
#import "STTwitter.h"
#import "DSWebViewController.h"
#import "SpecialEventsViewController.h"

@interface TwitterViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *twitterFeed;
@property (strong, nonatomic) NSString *tweetURL;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshBarButtonItem;

- (void)scrollToTop;

@end

@implementation TwitterViewController

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self updateTwitterFeed];
    
    // Pull to Refresh
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.tableView sendSubviewToBack:self.refreshControl];
    
    // Mixpanel Analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Latest News"];
    [mixpanel flush];
    
    // Show Special Events based on date
    [self performSelector:@selector(showSpecialEvents) withObject:nil afterDelay:1.0];
}

- (void)showSpecialEvents
{
    NSString *dateString = @"24-Aug-14";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yy";
    NSDate *picnicDate = [dateFormatter dateFromString:dateString];
    
    NSDate *currentDate = [NSDate date];
    
    if (currentDate < picnicDate) {
        [self performSegueWithIdentifier:@"toSpecialEventsViewControllerSegue" sender:nil];
        //NSLog(@"Special Events Triggered");
    } else {
        //NSLog(@"pecial Events -NOT- Triggered");
    }
}

- (void)updateTwitterFeed
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY
                                                            consumerSecret:TWITTER_CONSUMER_SECRET];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        [twitter getUserTimelineWithScreenName:@"WholeWayHouse" successBlock:^(NSArray *statuses) {
            self.twitterFeed = [NSMutableArray arrayWithArray:statuses];
            [self.tableView reloadData];
            
            // Set the left UIBarButtonItem back to the refresh icon
            self.navigationItem.leftBarButtonItem = self.refreshBarButtonItem;
        } errorBlock:^(NSError *error) {
            NSLog(@"%@", error.debugDescription);
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error.debugDescription);
    }];
}

// Pull to Refresh
- (void)handleRefresh:(UIRefreshControl *)refreshControl
{
    // Switch the left UIBarButtonItem to an UIActivityIndicator that shows loading animation
    [self leftItemButtonWithActivityIndicator];
    
    // Update pull-to-refresh section at the top of the view
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdate = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
    
    [self updateTwitterFeed];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toWebViewControllerSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[DSWebViewController class]]) {
            DSWebViewController *nextViewController = (DSWebViewController *)segue.destinationViewController;
            nextViewController.url = (NSString *)sender;
        }
    }
    
//    if ([segue.identifier isEqualToString:@"toSpecialEventsViewControllerSegue"]) {
//        if ([segue.destinationViewController isKindOfClass:[SpecialEventsViewController class]]) {
//            SpecialEventsViewController *nextViewController = (SpecialEventsViewController *)segue.destinationViewController;
//            nextViewController.transitioningDelegate = self;
//            nextViewController.modalPresentationStyle = UIModalPresentationCustom;
//        }
//    }

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.twitterFeed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *tweet = self.twitterFeed[indexPath.row];
    
    UILabel *tweetByline1 = (UILabel *)[cell viewWithTag:100];
    UILabel *tweetByline2 = (UILabel *)[cell viewWithTag:101];
    
    NSString *tweetAuthor = tweet[@"user"][@"screen_name"];
    NSString *date = tweet[@"created_at"];
    NSString *tweetText= [tweet[@"text"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    //NSString *tweetClient = tweet[@"source"];

    // Use STTwitter category to convert created_at date string into an NSDate
    NSDateFormatter *df = [NSDateFormatter st_TwitterDateFormatter];
    NSDate *postedDate = [df dateFromString:date];
    
    // Use my own Formatter to convert NSDate back into desired formatted string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    NSString *stringFromDate = [formatter stringFromDate:postedDate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *timeFromDate = [timeFormatter stringFromDate:postedDate];
    
    tweetByline1.text = [NSString stringWithFormat:@"%@", stringFromDate];
    tweetByline2.text = [NSString stringWithFormat:@"By @%@ at %@", tweetAuthor, timeFromDate];
    
    UILabel *twitterText = (UILabel *)[cell viewWithTag:102];
    twitterText.text = tweetText;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *tweet = self.twitterFeed[indexPath.row];
    
    NSString *tweetAuthor = tweet[@"user"][@"screen_name"];
    NSString *tweetID = tweet[@"id_str"];
    NSString *expandedURL = @"";
    NSDictionary *tweetEntity = tweet[@"entities"];
    
    NSArray *urls = tweetEntity[@"urls"];
    
    if (urls.count > 0) {
        NSDictionary *url0 = urls[0];
        expandedURL = url0[@"expanded_url"];
        NSLog(@"%@", expandedURL);
    }
    
    if ([expandedURL isEqualToString:@""]) {
        expandedURL = [NSString stringWithFormat:@"https://twitter.com/%@/status/%@", tweetAuthor, tweetID];
    }
    
    [self performSegueWithIdentifier:@"toWebViewControllerSegue" sender:expandedURL];
}

#pragma mark - IB Actions

- (IBAction)refreshBarButtonItemPressed:(UIBarButtonItem *)sender
{
    // Switch the left UIBarButtonItem to an UIActivityIndicator that shows loading animation
    [self leftItemButtonWithActivityIndicator];
    
    // Trigger the process to refresh the Twitter feed
    [self handleRefresh:self.refreshControl];
}

// UIActivityIndicator used to show that the feed is being refreshed
// Source: http://stackoverflow.com/questions/2965737/replace-uibarbuttonitem-with-uiactivityindicatorview

- (void)leftItemButtonWithActivityIndicator
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.leftBarButtonItem = activityItem;
}

- (IBAction)alertBarButtonItemPressed:(UIBarButtonItem *)sender
{
//    //self.containerView.hidden = !self.containerView.hidden;
//    if (self.containerView.hidden == YES) {
//        self.containerView.hidden = NO;
//        [UIView animateWithDuration:0.2f
//                              delay:0.0f
//                            options:UIViewAnimationOptionCurveEaseIn
//                         animations:^{
//                             self.containerView.frame = CGRectMake(0, 64, 320, 350);
//                         }
//                         completion:^(BOOL finished) {
//                             //
//                         }
//         ];
//    } else {
//        [UIView animateWithDuration:0.2f
//                              delay:0.0f
//                            options:UIViewAnimationOptionCurveEaseIn
//                         animations:^{
//                             self.containerView.frame = CGRectMake(0, -286, 320, 350);
//                         }
//                         completion:^(BOOL finished) {
//                             self.containerView.hidden = YES;
//                         }
//         ];
//    }
    [self performSegueWithIdentifier:@"toSpecialEventsViewControllerSegue" sender:nil];
    
}

- (void)scrollToTop
{
    // Source: http://stackoverflow.com/questions/9450302/tell-uiscrollview-to-scroll-to-the-top?rq=1
    
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
}



@end
