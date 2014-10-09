//
//  GradientView.m
//  WWH
//
//  Created by Michael Whang on 10/3/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[_gradientTopColor CGColor], (id)[_gradientBottomColor CGColor], nil];
    
    if ([[self.layer.sublayers objectAtIndex:0] isKindOfClass:[CAGradientLayer class]]) {
        [[self.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
    }

    [self.layer insertSublayer:gradient atIndex:0];

}

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self)
//        [self commonInit];
//    return self;
//}
//
//- (void)awakeFromNib
//{
//    [self commonInit];
//}
//
//- (void)commonInit
//{
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
//    [self.layer insertSublayer:gradient atIndex:0];
//}



@end
