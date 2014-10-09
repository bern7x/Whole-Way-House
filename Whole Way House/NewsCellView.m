//
//  NewsCellView.m
//  WWH
//
//  Created by Michael Whang on 9/20/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "NewsCellView.h"

@implementation NewsCellView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    [self.layer setBorderColor:[UIColor colorWithRed:87.0/255.0 green:175.0/255.0 blue:193.0/255.0 alpha:1].CGColor];
    [self.layer setBorderWidth:1.0f];
}

@end
