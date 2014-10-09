//
//  MediaPFTableViewCell.m
//  WWH
//
//  Created by Michael Whang on 8/31/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "MediaPFTableViewCell.h"

@implementation MediaPFTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)prepareForReuse
{
    self.mediaImageView.image = nil;
}

@end
