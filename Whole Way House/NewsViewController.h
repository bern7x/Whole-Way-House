//
//  NewsViewController.h
//  WWH
//
//  Created by Michael Whang on 8/16/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)scrollToTop;

@end
