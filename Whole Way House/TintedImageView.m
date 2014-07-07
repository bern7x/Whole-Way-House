//
//  TintedImageView.m
//  WWH
//
//  Created by Michael Whang on 6/18/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "TintedImageView.h"

@implementation TintedImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    // Make it so that instances of this UIImageView subclass take on the tint as defined via Interface Builder
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
