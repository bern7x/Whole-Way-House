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
    
    // Embedded YouTube video
    NSURL *url = [NSURL URLWithString:@"http://www.youtube.com/embed/9HNSlVfqt1w?showinfo=0&modestbranding=1&rel=0&showsearch=0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.youTubeWebView loadRequest:request];
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
    NSString *urlString = @"http://bit.ly/wwh-donate";
    NSURL *url =[NSURL URLWithString:urlString];
    if(![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (IBAction)moreDetailsBarButtonItemPressed:(UIBarButtonItem *)sender
{
    NSString *urlString = @"http://bit.ly/wwh-donate";
    NSURL *url =[NSURL URLWithString:urlString];
    if(![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}


@end
