//
//  VersesViewController.m
//  WWH
//
//  Created by Michael Whang on 10/5/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "VersesViewController.h"

@interface VersesViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) int currentPage;

@end

@implementation VersesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView.delegate = self;
    [self.scrollView setScrollsToTop:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma - UIScrollView Device Rotation Handling

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    self.currentPage = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
}

- (void)viewWillLayoutSubviews
{
    self.scrollView.contentOffset = CGPointMake(self.currentPage * self.scrollView.bounds.size.width, 0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat screenWidth = self.view.frame.size.width;
    if (scrollView == self.scrollView) {
        self.pageControl.currentPage = floorf(scrollView.contentOffset.x/screenWidth);
    }
}

@end
