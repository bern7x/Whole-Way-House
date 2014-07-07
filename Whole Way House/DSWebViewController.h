//
//  DSFacebookWebViewController.h
//  Golf Vancouver
//
//  Created by Michael Whang on 4/15/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSWebViewController : UIViewController <UIActionSheetDelegate>

// IB Outlets
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *statusView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UILabel *siteLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;

// IB Actions
- (IBAction)actionBarButtonItemPressed:(UIBarButtonItem *)sender;
- (IBAction)dismissBarButtonItemPressed:(UIBarButtonItem *)sender;

// Instance Variables
@property (strong, nonatomic) NSString *url;

@end
