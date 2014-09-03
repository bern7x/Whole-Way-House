//
//  NewsViewController.m
//  WWH
//
//  Created by Michael Whang on 8/16/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "STTwitter.h"
#import "DSWebViewController.h"

@interface NewsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NewsTableViewCell *customCell;
@property (strong, nonatomic) NSMutableArray *twitterFeed;
@property (strong, nonatomic) NSString *tweetURL;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation NewsViewController

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
    
    // TableView setup
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:216.0/255.0 blue:224.0/255.0 alpha:1];
//    [self.tableView setContentInset:UIEdgeInsetsMake(108, 0, 0, 0)];
    
    // Update Twitter Feed
    [self updateTwitterFeed];
    
    // Pull to Refresh
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.tableView sendSubviewToBack:self.refreshControl];

    // Mixpanel Analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"News"];
    [mixpanel flush];
    
    // Bug workaround - Required to set proper height of tableView for 3.5 inch screens
    // I think this is necessary due to tableView within containerView not having a chance to update its
    // autolayout constraints in time, which is why setNeedsUpdateContraints is required
    [self.tableView setFrame:self.view.frame];
    [self.tableView setContentInset:UIEdgeInsetsMake(64.0, 0.0, 54.0, 0.0)];
    [self.tableView setNeedsUpdateConstraints];
}

#pragma mark - Helper Methods

// Twitter API using STTwitter library
// Source: https://github.com/nst/STTwitter

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
    //    // Switch the left UIBarButtonItem to an UIActivityIndicator that shows loading animation
    //    [self leftItemButtonWithActivityIndicator];
    
    // Update pull-to-refresh section at the top of the view
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdate = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
    
    [self updateTwitterFeed];
    [refreshControl endRefreshing];
}

// Scroll to top

- (void)scrollToTop
{
    // Source: http://stackoverflow.com/questions/9450302/tell-uiscrollview-to-scroll-to-the-top?rq=1
    
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
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

#define FONT_NAME @"HelveticaNeue"
#define FONT_SIZE 14.0

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
//    cell.alphaLabel.text = @"Sunday, August 24, 2014";
//    cell.betaLabel.text = @"By @WholeWayHouse at 12:12pm";
//    cell.charlieLabel.text = @"Have you seen how many awesome peeps are helping make #WWHPicnic2014 more awesome? #thankyou #givingback... http://fb.me/33xktu3xP";
    
    NSDictionary *tweet = self.twitterFeed[indexPath.row];
    NSString *tweetAuthor = tweet[@"user"][@"screen_name"];
    NSString *date = tweet[@"created_at"];
    NSString *tweetText = [tweet[@"text"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
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
    
    cell.alphaLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE];
    cell.alphaLabel.text = [NSString stringWithFormat:@"%@", stringFromDate];
    
    cell.betaLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    cell.betaLabel.text = [NSString stringWithFormat:@"By @%@ at %@", tweetAuthor, timeFromDate];
    
    cell.charlieLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    cell.charlieLabel.contentMode = UIViewContentModeTop;
    cell.charlieLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.charlieLabel.text = tweetText;
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // calculate a height based on a cell
    
    if (!self.customCell) {
        self.customCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    // configure the cell
   
//    self.customCell.alphaLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
//    self.customCell.alphaLabel.text = @"Sunday, August 24, 2014";
//    
//    self.customCell.betaLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
//    self.customCell.betaLabel.text = @"By @WholeWayHouse at 12:12pm";
//    
//    self.customCell.charlieLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
//    self.customCell.charlieLabel.text = @"Have you seen how many awesome peeps are helping make #WWHPicnic2014 more awesome? #thankyou #givingback... http://fb.me/33xktu3xP";
    
    NSDictionary *tweet = self.twitterFeed[indexPath.row];
    NSString *tweetAuthor = tweet[@"user"][@"screen_name"];
    NSString *date = tweet[@"created_at"];
    NSString *tweetText= [tweet[@"text"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
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
    
    self.customCell.alphaLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE];
    self.customCell.alphaLabel.text = [NSString stringWithFormat:@"%@", stringFromDate];
    
    self.customCell.betaLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    self.customCell.betaLabel.text = [NSString stringWithFormat:@"By @%@ at %@", tweetAuthor, timeFromDate];
    
    self.customCell.charlieLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.5]; // can't figure out what is causing label to truncate ever so slightly early - therefore setting font size to be slightly larger to ensure no truncation
    self.customCell.charlieLabel.contentMode = UIViewContentModeTop;
    self.customCell.charlieLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.customCell.charlieLabel.text = tweetText;
    
    // layout the cell
    
    [self.customCell layoutIfNeeded];
    
    // get the height for the cell
    
    CGFloat height = [self.customCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // padding of 1 point (cell separator) + CELL_PADDING
    
    return height + 1 + 10;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
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
        //NSLog(@"%@", expandedURL);
    }
    
    if ([expandedURL isEqualToString:@""]) {
        expandedURL = [NSString stringWithFormat:@"https://twitter.com/%@/status/%@", tweetAuthor, tweetID];
    }
    
    [self performSegueWithIdentifier:@"toWebViewControllerSegue" sender:expandedURL];
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toWebViewControllerSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[DSWebViewController class]]) {
            DSWebViewController *nextViewController = (DSWebViewController *)segue.destinationViewController;
            nextViewController.url = (NSString *)sender;
        }
    }
}


@end
