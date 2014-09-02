//
//  MediaPFTableViewCell.h
//  WWH
//
//  Created by Michael Whang on 8/31/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import <Parse/Parse.h>

@interface MediaPFTableViewCell : PFTableViewCell

@property (strong, nonatomic) IBOutlet PFImageView *mediaImageView;
@property (strong, nonatomic) IBOutlet UIView *mainBackgroundView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *dateBackgroundView;

@end
