//
//  DSFacebookWebViewController.m
//  Golf Vancouver
//
//  Created by Michael Whang on 4/15/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "DSWebViewController.h"

@interface DSWebViewController () <UIWebViewDelegate>

@end

@implementation DSWebViewController

- (NSString *)url
{
    if (!_url) {
        _url = [[NSString alloc] init];
    }
    return _url;
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
    
    self.webView.delegate = self;
    
    //NSLog(@"%@", self.url);
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    // Mixpanel Analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    NSString *mixpanelTracking = [NSString stringWithFormat:@"Webview: %@", self.url];
    [mixpanel track:mixpanelTracking];
    [mixpanel flush];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    // Navigation bar work
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:0.9 alpha:0.5]];
//    self.navigationBar.barTintColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//    self.navigationBar.translucent = YES;
//    self.siteLabel.text = @"Loading...";
//    self.urlLabel.text = self.url;
//    
//    //background for Status bar
//    self.statusView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//}

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

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    [self updateTitle:webView];
}

#pragma mark - IB Actions

- (IBAction)actionBarButtonItemPressed:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (IBAction)dismissBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper Methods

- (void)updateTitle:(UIWebView*)aWebView
{
    NSString* pageTitle = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.siteLabel.text = pageTitle;
    self.urlLabel.text = self.url;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self openInSafari];
                    NSLog(@"Open in Safari button pressed");
                    break;
//                case 1:
//                    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
//                    NSLog(@"Cancel button pressed");
//                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)openInSafari
{
    NSURL *url =[NSURL URLWithString:self.url];
    if(![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}






@end
