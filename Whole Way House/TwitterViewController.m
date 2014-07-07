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

@interface TwitterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *twitterFeed;
@property (strong, nonatomic) NSString *tweetURL;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshBarButtonItem;

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
}

- (void)updateTwitterFeed
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY
                                                            consumerSecret:TWITTER_CONSUMER_SECRET];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        [twitter getUserTimelineWithScreenName:@"WholeWayHouse" successBlock:^(NSArray *statuses) {
            self.twitterFeed = [NSMutableArray arrayWithArray:statuses];
            [self.tableView reloadData];
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
    NSString *tweetText = tweet[@"text"];
    
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

- (IBAction)refreshBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self handleRefresh:self.refreshControl];
}




























@end
