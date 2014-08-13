//
//  SpecialEventsViewController.m
//  WWH
//
//  Created by Michael Whang on 7/10/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "SpecialEventsViewController.h"

@interface SpecialEventsViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *youTubeWebView;
@property (strong, nonatomic) LinkLibrary *links;

@end

@implementation SpecialEventsViewController

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
    
    // Initialize Link Library
    self.links = [LinkLibrary sharedLinkLibrary];
    
    // Embedded YouTube video
    NSURL *url = [NSURL URLWithString:self.links.linkDictionary[@"interview"]];
    if (url && url.scheme && url.host) {
        // Check to see that a valid URL is contained within the dynamic link library retrieved url
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.youTubeWebView loadRequest:request];
    } else {
        // In case dynamic link library is too slow for the initial pop-up, use this hardcoded backup
        NSURL *backup = [NSURL URLWithString:@"http://www.youtube.com/embed/9HNSlVfqt1w?showinfo=0&modestbranding=1&rel=0&showsearch=0"];
        NSURLRequest *request = [NSURLRequest requestWithURL:backup];
        [self.youTubeWebView loadRequest:request];
        NSLog(@"Backup used");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"toWebViewControllerSegue"]) {
//        if ([segue.destinationViewController isKindOfClass:[DSWebViewController class]]) {
//            DSWebViewController *nextViewController = (DSWebViewController *)segue.destinationViewController;
//            nextViewController.url = (NSString *)sender;
//        }
//    }
//}

#pragma mark - IB Actions

- (IBAction)closeBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)purchaseTicketsBarButtonItemPressed:(UIBarButtonItem *)sender
{
    NSString *urlString = self.links.linkDictionary[@"donate"];
    NSURL *url =[NSURL URLWithString:urlString];
    if(![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (IBAction)moreDetailsBarButtonItemPressed:(UIBarButtonItem *)sender
{
    NSString *urlString = self.links.linkDictionary[@"donate"];
    NSURL *url =[NSURL URLWithString:urlString];
    if(![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}


@end
