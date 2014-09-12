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
#import "DSWebViewController.h"

@interface MediaViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *mediaArray;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;

@end

@implementation MediaViewController

- (NSMutableArray *)mediaArray
{
    if (!_mediaArray) {
        _mediaArray = [[NSMutableArray alloc] init];
    }
    
    return _mediaArray;
}

- (NSMutableDictionary *)cachedImages
{
    if (!_cachedImages) {
        _cachedImages = [[NSMutableDictionary alloc] init];
    }
    
    return _cachedImages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:216.0/255.0 blue:224.0/255.0 alpha:1];
    
    // Pull-to-Refresh
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.tableView sendSubviewToBack:self.refreshControl];
    
    // Fetch Media objects from Parse
    [self fetchMedia];
    
    // Bug workaround - Required to set proper height of tableView for 3.5 inch screens
    // I think this is necessary due to tableView within containerView not having a chance to update its
    // autolayout constraints in time, which is why setNeedsUpdateContraints is required
//    [self.tableView setFrame:self.view.frame];
//    [self.tableView setContentInset:UIEdgeInsetsMake(64.0, 0.0, 49.0, 0.0)];
//    [self.tableView setNeedsUpdateConstraints];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                media.color = object[@"color"];
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
    return [self.mediaArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaPFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MediaCell" forIndexPath:indexPath];
    
    Media *media = self.mediaArray[indexPath.row];
    
    // Background image setup + caching
    // Hints for designing this cache model: http://kemal.co/index.php/2013/02/loading-images-asynchronously-on-uitableview/
    // Had to adapt to Parse model, which meant the GCD stuff really wasn't required
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld", (long)indexPath.row];
    
    if ([self.cachedImages objectForKey:identifier] != nil) {
        cell.mediaImageView.image = [self.cachedImages valueForKey:identifier];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Media"];
        [query getObjectInBackgroundWithId:media.objectId block:^(PFObject *object, NSError *error) {
            PFFile *photoFile = object[@"photoData"];
            cell.mediaImageView.file = photoFile;
            [cell.mediaImageView loadInBackground:^(UIImage *image, NSError *error) {
                if ([tableView indexPathForCell:cell].row == indexPath.row) {
                    [self.cachedImages setValue:image forKey:identifier];
                    cell.mediaImageView.image = [self.cachedImages valueForKey:identifier];
                }
            }];
        }];
    }
    
    // Setup publish date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    NSString *stringFromDate = [formatter stringFromDate:media.publishDate];
    cell.dateLabel.text = stringFromDate;
    
    // Setup background view color for date and main body text
    NSNumber *red = media.color[@"red"];
    NSNumber *green = media.color[@"green"];
    NSNumber *blue = media.color[@"blue"];
    NSNumber *alpha = media.color[@"alpha"];
    cell.dateBackgroundView.layer.backgroundColor = [[UIColor colorWithRed:[red floatValue]/255.0 green:[green floatValue]/255.0 blue:[blue floatValue]/255.0 alpha:[alpha floatValue]] CGColor];
    cell.mainBackgroundView.layer.backgroundColor = [[UIColor colorWithRed:[red floatValue]/255.0 green:[green floatValue]/255.0 blue:[blue floatValue]/255.0 alpha:[alpha floatValue]] CGColor];
    
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
    
    Media *media = self.mediaArray[indexPath.row];
    NSString *url = media.website;
    
    if (url) {
        [self performSegueWithIdentifier:@"toWebViewControllerSegue" sender:url];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSString *url = (NSString *)sender;
    if ([segue.identifier isEqualToString:@"toWebViewControllerSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[DSWebViewController class]]) {
            DSWebViewController *nextViewController = (DSWebViewController *)segue.destinationViewController;
            nextViewController.url = url;
        }
    }
}


@end
