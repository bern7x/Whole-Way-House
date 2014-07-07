//
//  BoardViewController.h
//  WWH
//
//  Created by Michael Whang on 6/14/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardViewController : UIViewController

// IB Outlets
@property (strong, nonatomic) IBOutlet UIView *statusView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

// IB Actions
- (IBAction)dismissBarButtonItemPressed:(UIBarButtonItem *)sender;

// Instance Variables
@property (strong, nonatomic) NSString *url;

@end
