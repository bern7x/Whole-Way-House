//
//  Sponsor.h
//  WWH
//
//  Created by Michael Whang on 6/15/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sponsor : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *tagline;
@property (strong, nonatomic) NSString *website;

- (id)initWithData:(NSDictionary *)data;

@end
