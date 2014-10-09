//
//  ContainerViewController.h
//  WWH
//
//  Created by Michael Whang on 8/16/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *containerSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *newsContainerView;
@property (weak, nonatomic) IBOutlet UIView *mediaContainerView;
@property (weak, nonatomic) IBOutlet UIView *volunteerContainerView;

@end
