//
//  SponsorsInfoViewController.m
//  WWH
//
//  Created by Michael Whang on 10/3/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "SponsorsInfoViewController.h"
#import "GradientView.h"
#import "LinkLibrary.h"
#import "DSWebViewController.h"

@interface SponsorsInfoViewController ()
@property (strong, nonatomic) IBOutlet GradientView *contentView;
@property (strong, nonatomic) LinkLibrary *links;

@end

@implementation SponsorsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Load Dynamic Link Library
    self.links = [LinkLibrary sharedLinkLibrary];
}

- (void)viewDidLayoutSubviews
{
    [_contentView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"fromSponsorsInfoToWebViewControllerSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[DSWebViewController class]]) {
            DSWebViewController *nextViewController = (DSWebViewController *)segue.destinationViewController;
            nextViewController.url = sender;
        }
    }
}

#pragma - IB Actions

- (IBAction)testBarButtonItemPressed:(UIBarButtonItem *)sender
{
    NSString *donate = self.links.linkDictionary[@"donate"];
    [self performSegueWithIdentifier:@"fromSponsorsInfoToWebViewControllerSegue" sender:donate];
}


@end
