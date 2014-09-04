//
//  ShareSetting.m
//  WWH
//
//  Created by Michael Whang on 8/23/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "ShareSetting.h"

@implementation ShareSetting

+ (id)sharedSettings
{
    static id shareSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareSettings = [[self alloc] init];
    });
    return shareSettings;
}

@end
