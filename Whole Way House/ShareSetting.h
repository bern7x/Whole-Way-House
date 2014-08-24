//
//  ShareSetting.h
//  WWH
//
//  Created by Michael Whang on 8/23/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareSetting : NSObject

@property (nonatomic, strong) NSString *currentView;

+ (id)sharedSettings;

@end
