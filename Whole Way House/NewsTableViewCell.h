//
//  NewsTableViewCell.h
//  WWH
//
//  Created by Michael Whang on 8/23/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface NewsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *innerContentView;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UILabel *alphaLabel;
@property (strong, nonatomic) IBOutlet UILabel *betaLabel;
@property (strong, nonatomic) IBOutlet UILabel *charlieLabel;

@end
