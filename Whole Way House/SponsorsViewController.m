//
//  SponsorsViewController.m
//  WWH
//
//  Created by Michael Whang on 6/15/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "SponsorsViewController.h"
#import "SponsorData.h"
#import "Sponsor.h"
#import "DSWebViewController.h"
#import "SponsorsSliderViewController.h"

@interface SponsorsViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) NSMutableArray *sponsors;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end

@implementation SponsorsViewController

- (NSMutableArray *)sponsors
{
    if (!_sponsors) {
        _sponsors = [[NSMutableArray alloc] init];
    }
    
    return _sponsors;
}

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
    
    self.containerView.hidden = YES;
    
/*  
    // Loading sponsors from locally stored data
    for (NSMutableDictionary *sponsorData in [SponsorData allSponsors]) {
        Sponsor *sponsor = [[Sponsor alloc] initWithData:sponsorData];
        [self.sponsors addObject:sponsor];
    }
*/
    
    // Load sponsors from Parse back-end
    [self fetchSponsors];
    
    // Customize look of table cells
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 5, 0); // top, left, bottom, right
    self.tableView.contentInset = inset;
    
    // Mixpanel Analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Sponsors"];
    [mixpanel flush];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.containerView.hidden == NO) {
        [self sponsorBarButtonItemPressed:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"fromSponsorsToWebViewController"]) {
        if ([segue.destinationViewController isKindOfClass:[DSWebViewController class]]) {
            DSWebViewController *nextViewController = (DSWebViewController *)segue.destinationViewController;
            nextViewController.url = sender;
        }
    }
    
    if ([segue.identifier isEqualToString:@"sponsorsSliderViewControllerSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[SponsorsSliderViewController class]]) {
            SponsorsSliderViewController *nextViewController = (SponsorsSliderViewController *)segue.destinationViewController;
            nextViewController.transitioningDelegate = self;
            nextViewController.modalPresentationStyle = UIModalPresentationCustom;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.sponsors count];
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Sponsor *sponsor = self.sponsors[indexPath.row];
//    cell.textLabel.text = sponsor.name;
//    cell.detailTextLabel.text = sponsor.tagline;
    
    UILabel *sponsorNameLabel = (UILabel *)[cell viewWithTag:101];
    sponsorNameLabel.text = sponsor.name;
    
    UILabel *sponsorDetailLabel = (UILabel *)[cell viewWithTag:102];
    sponsorDetailLabel.text = sponsor.tagline;
    
    // Assign our own background image for the cell
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Sponsor *sponsor = self.sponsors[indexPath.row];
    [self performSegueWithIdentifier:@"fromSponsorsToWebViewController" sender:sponsor.website];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Sponsor *sponsor = self.sponsors[indexPath.row];
    [self performSegueWithIdentifier:@"fromSponsorsToWebViewController" sender:sponsor.website];
}

#pragma mark - IB Actions

- (IBAction)sponsorBarButtonItemPressed:(UIBarButtonItem *)sender
{
    //self.containerView.hidden = !self.containerView.hidden;
    if (self.containerView.hidden == YES) {
        self.containerView.hidden = NO;
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.containerView.frame = CGRectMake(0, 64, 320, 350);
                         }
                         completion:^(BOOL finished) {
                             //
                         }
         ];
    } else {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.containerView.frame = CGRectMake(0, -286, 320, 350);
                         }
                         completion:^(BOOL finished) {
                             self.containerView.hidden = YES;
                         }
         ];
    }
}

#pragma mark - Helper Methods

// Scroll-to-top (triggered by TabBarController)
- (void)scrollToTop
{
    // Source: http://stackoverflow.com/questions/9450302/tell-uiscrollview-to-scroll-to-the-top?rq=1
    
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
}

- (void)fetchSponsors
{
    PFQuery *query = [PFQuery queryWithClassName:@"Sponsor"];
    [query whereKey:@"status" equalTo:@"Active"];
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Start network activity indicator
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            // The find was successful
            for (PFObject *object in objects) {
                Sponsor *sponsor = [[Sponsor alloc] init];
                sponsor.name = object[@"name"];
                sponsor.tagline = object[@"detail"];
                sponsor.website = object[@"website"];
                [self.sponsors addObject:sponsor];
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

@end
