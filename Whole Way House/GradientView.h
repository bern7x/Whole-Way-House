//
//  GradientView.h
//  WWH
//
//  Created by Michael Whang on 10/3/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

// Source: http://stackoverflow.com/questions/23074539/programmatically-create-a-uiview-with-color-gradient

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface GradientView : UIView

@property (nonatomic) IBInspectable UIColor *gradientTopColor;
@property (nonatomic) IBInspectable UIColor *gradientBottomColor;

@end
