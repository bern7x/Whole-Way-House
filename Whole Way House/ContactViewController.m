//
//  ContactViewController.m
//  Whole Way House
//
//  Created by Michael Whang on 6/7/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "ContactViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DSWebViewController.h"
#import "BoardViewController.h"
#import <MessageUI/MessageUI.h>

@interface ContactViewController () <MKMapViewDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIImageView *wwhLogoImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *versesScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ContactViewController

#define TUNGSTEN_COLOR colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f

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
    
    self.mapView.delegate = self;
    self.versesScrollView.delegate = self;
    //self.versesScrollView.contentSize = CGSizeMake(960.0, 150.0);
    
    [self setupMap];
    [self setupLogo];
    
    // Mixpanel Analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Contact Us"];
    [mixpanel flush];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMap
{
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(49.2815218, -123.10904189999997);
    point.title = @"Whole Way House";
    point.subtitle = @"165 W Pender St, Vancouver, BC, V6B 1S4";
    
    [self.mapView addAnnotation:point];
    [self.mapView setCenterCoordinate:point.coordinate];
    [self.mapView selectAnnotation:point animated:YES];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point.coordinate, 1500, 1500);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)setupLogo
{
    self.wwhLogoImageView.layer.cornerRadius = 30.0;
    self.wwhLogoImageView.layer.backgroundColor = [[UIColor TUNGSTEN_COLOR] CGColor];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"fromContactToWebViewControllerSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[DSWebViewController class]]) {
            DSWebViewController *nextViewController = (DSWebViewController *)segue.destinationViewController;
            nextViewController.url = sender;
        }
    } else if ([segue.identifier isEqualToString:@"toBoardViewControllerSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[BoardViewController class]]) {
            BoardViewController *nextViewController = (BoardViewController *)segue.destinationViewController;
            nextViewController.url = sender;
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.versesScrollView) {
        self.pageControl.currentPage = floorf(scrollView.contentOffset.x/320);
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.pinColor = MKPinAnnotationColorRed;
    
    UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //advertButton.frame = CGRectMake(0, 0, 10, 16);
    //advertButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //advertButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //[advertButton setImage:[UIImage imageNamed:@"fakeArrow"] forState:UIControlStateNormal];
    annView.rightCalloutAccessoryView = advertButton;
    
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    //annView.calloutOffset = CGPointMake(-5, 5);
    
    return annView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self mapsButtonPressed:(UIButton *)control];
    NSLog(@"Accessory button clicked");
}

- (void)mapsButtonPressed:(UIButton *)sender
{
    
    NSString *targetAddress = @"165 W Pender St, Vancouver, BC, V6B 1S4";
    
    NSString *mapString1 = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=Current+Location&daddr="];
    NSString *mapString2 = [targetAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    NSString *mapString3 = [NSString stringWithFormat:@",+%@", [self.course.location.city stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
//    NSString *mapString4 = [NSString stringWithFormat:@",+%@", [self.course.location.state stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSString *mapsURL = [NSString stringWithFormat:@"%@%@", mapString1, mapString2];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapsURL]];
}

#pragma mark - MailComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Contact Buttons

- (IBAction)phoneButtonPressed:(UIButton *)sender
{
    NSString *phoneNumber = @"1-604-428-5115";
    NSString *phoneURL = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURL]];
}

- (IBAction)locationButtonPressed:(UIButton *)sender
{
    [self mapsButtonPressed:nil];
}

- (IBAction)emailButtonPressed:(UIButton *)sender
{
    NSString *emailTitle = @"Inquiry";
    NSString *emailAddress = @"info@wholewayhouse.ca";
    NSArray *toRecipients = [NSArray arrayWithObject:emailAddress];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:@"" isHTML:YES];
    [mc setToRecipients:toRecipients];
    
    [self presentViewController:mc animated:YES completion:nil];
}

- (IBAction)websiteButtonPressed:(UIButton *)sender
{
    NSString *url = @"http://www.wholewayhouse.ca";
    [self performSegueWithIdentifier:@"fromContactToWebViewControllerSegue" sender:url];
}

- (IBAction)twitterButtonPressed:(UIButton *)sender
{
    NSString *url = @"https://twitter.com/wholewayhouse";
    [self performSegueWithIdentifier:@"fromContactToWebViewControllerSegue" sender:url];
}

- (IBAction)instagramButtonPressed:(UIButton *)sender
{
    NSString *url = @"http://instagram.com/wholewayhouse";
    [self performSegueWithIdentifier:@"fromContactToWebViewControllerSegue" sender:url];
}

- (IBAction)facebookButtonPressed:(UIButton *)sender
{
    NSString *url = @"https://www.facebook.com/WholeWayHouse";
    [self performSegueWithIdentifier:@"fromContactToWebViewControllerSegue" sender:url];
}

- (IBAction)boardButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"toBoardViewControllerSegue" sender:nil];
}





@end
