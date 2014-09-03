//
//  Media.h
//  WWH
//
//  Created by Michael Whang on 8/31/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Media : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSDate *publishDate;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) UIImage *photoImage;
@property (strong, nonatomic) NSDictionary *color;

@end
