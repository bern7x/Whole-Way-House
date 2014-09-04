//
//  VolunteerViewController.m
//  WWH
//
//  Created by Michael Whang on 9/4/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "VolunteerViewController.h"
#import "DSWebViewController.h"
#import <MessageUI/MessageUI.h>

@interface VolunteerViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) LinkLibrary *links;

@end

@implementation VolunteerViewController

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
    
    // Bug workaround - Required to set proper height of tableView for 3.5 inch screens
    // I think this is necessary due to tableView within containerView not having a chance to update its
    // autolayout constraints in time, which is why setNeedsUpdateContraints is required
    if (self.view.frame.size.height == 480.0) {
        [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0.0, 90.0, 0.0)];
    }
    [self.scrollView setNeedsUpdateConstraints];
    
    // Load Dynamic Link Library
    self.links = [LinkLibrary sharedLinkLibrary];
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

#pragma mark - IB Actions

- (IBAction)volunteerQuestionnaireButtonPressed:(UIButton *)sender
{
    NSString *questionnaire = self.links.linkDictionary[@"questionnaire"];
    [self performSegueWithIdentifier:@"toWebViewControllerSegue" sender:questionnaire];
}

- (IBAction)volunteerScheduleButtonPressed:(UIButton *)sender
{
    NSString *signup = self.links.linkDictionary[@"signup"];
    [self performSegueWithIdentifier:@"toWebViewControllerSegue" sender:signup];
}

- (IBAction)emailButtonPressed:(UIButton *)sender
{
    NSString *emailTitle = @"Volunteer Inquiry";
    NSString *emailAddress = @"info@wholewayhouse.ca";
    NSArray *toRecipients = [NSArray arrayWithObject:emailAddress];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:@"" isHTML:YES];
    [mc setToRecipients:toRecipients];
    
    [self presentViewController:mc animated:YES completion:nil];
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
