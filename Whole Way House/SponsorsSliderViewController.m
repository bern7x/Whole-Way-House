//
//  SponsorsSliderViewController.m
//  WWH
//
//  Created by Michael Whang on 6/17/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "SponsorsSliderViewController.h"
#import "SponsorsViewController.h"
#import <MessageUI/MessageUI.h>

@interface SponsorsSliderViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *sliderView;

@end

@implementation SponsorsSliderViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)closeSliderGesture:(UISwipeGestureRecognizer *)sender
{
    SponsorsViewController *parentVC = (SponsorsViewController *)[self parentViewController];
    [parentVC sponsorBarButtonItemPressed:nil];
}

- (IBAction)phoneButtonPressed:(UIButton *)sender
{
    NSString *phoneNumber = @"1-604-428-5115";
    NSString *phoneURL = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURL]];
}

- (IBAction)emailButtonPressed:(UIButton *)sender
{
    SponsorsViewController *parentVC = (SponsorsViewController *)[self parentViewController];
    [parentVC sponsorBarButtonItemPressed:nil];
    
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

- (IBAction)paypalButtonPressed:(UIButton *)sender
{
    NSString *urlString = @"http://bit.ly/wwh-donate";
    NSURL *url =[NSURL URLWithString:urlString];
    if(![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
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

@end
