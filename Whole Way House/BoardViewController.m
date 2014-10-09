//
//  BoardViewController.m
//  WWH
//
//  Created by Michael Whang on 6/14/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "BoardViewController.h"

@interface BoardViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *boardScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) int currentPage;

@end

@implementation BoardViewController

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
    
    self.boardScrollView.delegate = self;
    
    // Mixpanel Analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Board of Directors"];
    [mixpanel flush];
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

#pragma - UIScrollView Device Rotation Handling

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    self.currentPage = self.boardScrollView.contentOffset.x / self.boardScrollView.bounds.size.width;
}

- (void)viewWillLayoutSubviews
{
    self.boardScrollView.contentOffset = CGPointMake(self.currentPage * self.boardScrollView.bounds.size.width, 0);
}

#pragma mark - IB Actions

- (IBAction)dismissBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat screenWidth = self.view.frame.size.width;
    if (scrollView == self.boardScrollView) {
        self.pageControl.currentPage = floorf(scrollView.contentOffset.x/screenWidth);
    }
}

@end
