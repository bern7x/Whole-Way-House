//
//  MediaViewController.m
//  WWH
//
//  Created by Michael Whang on 8/24/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "MediaViewController.h"
#import "MediaPFTableViewCell.h"
#import "Media.h"

@interface MediaViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *mediaArray;

@end

@implementation MediaViewController

- (NSMutableArray *)mediaArray
{
    if (!_mediaArray) {
        _mediaArray = [[NSMutableArray alloc] init];
    }
    
    return _mediaArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Pull-to-Refresh
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.tableView sendSubviewToBack:self.refreshControl];
    
    // Fetch Media objects from Parse
    [self fetchMedia];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [self.tableView setContentInset:UIEdgeInsetsMake(64.0, 0.0, 49.0, 0.0)];
}

#pragma mark - Helper Methods

// Pull-to-Refresh
- (void)handleRefresh:(UIRefreshControl *)refreshControl
{
    // Update pull-to-refresh section at the top of the view
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdate = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
    
    [self fetchMedia];
    [refreshControl endRefreshing];
}

// Fetch Media objects from Parse
- (void)fetchMedia
{
    PFQuery *query = [PFQuery queryWithClassName:@"Media"];
    [query whereKey:@"status" equalTo:@"Active"];
    [query orderByDescending:@"publishDate"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Start network activity indicator
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            // The find was successful
            
            self.mediaArray = nil;
            
            for (PFObject *object in objects) {
                Media *media = [[Media alloc] init];
                media.objectId = object.objectId;
                media.publishDate = object[@"publishDate"];
                media.title = object[@"title"];
                media.subtitle = object[@"subtitle"];
                media.website = object[@"website"];
                [self.mediaArray addObject:media];
            }
            // Stop network activity indicator
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [self.tableView reloadData];
        } else {
            // Log details of error
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mediaArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaPFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MediaCell" forIndexPath:indexPath];
    
    Media *media = self.mediaArray[indexPath.row];
    
    // Setup background image
    cell.mediaImageView.image = [UIImage imageNamed:@"MediaPlaceholder.png"];
    PFQuery *query = [PFQuery queryWithClassName:@"Media"];
    [query getObjectInBackgroundWithId:media.objectId block:^(PFObject *object, NSError *error) {
            PFFile *photoFile = object[@"photoData"];
            cell.mediaImageView.file = photoFile;
            [cell.mediaImageView loadInBackground];
    }];
    
    // Setup publish date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    NSString *stringFromDate = [formatter stringFromDate:media.publishDate];
    cell.dateLabel.text = stringFromDate;
    
    // Setup background view color for date and main body text
    cell.dateBackgroundView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    cell.mainBackgroundView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    
    // Setup main body title and description text
    cell.titleLabel.text = media.title;
    cell.descriptionLabel.text = media.subtitle;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSDictionary *tweet = self.twitterFeed[indexPath.row];
//    
//    NSString *tweetAuthor = tweet[@"user"][@"screen_name"];
//    NSString *tweetID = tweet[@"id_str"];
//    NSString *expandedURL = @"";
//    NSDictionary *tweetEntity = tweet[@"entities"];
//    
//    NSArray *urls = tweetEntity[@"urls"];
//    
//    // temp
//    NSString *tweetText= [tweet[@"text"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
//    NSLog(@"%@", tweetText);
//    
//    
//    if (urls.count > 0) {
//        NSDictionary *url0 = urls[0];
//        expandedURL = url0[@"expanded_url"];
//        NSLog(@"%@", expandedURL);
//    }
//    
//    if ([expandedURL isEqualToString:@""]) {
//        expandedURL = [NSString stringWithFormat:@"https://twitter.com/%@/status/%@", tweetAuthor, tweetID];
//    }
//    
//    [self performSegueWithIdentifier:@"toWebViewControllerSegue" sender:expandedURL];
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
