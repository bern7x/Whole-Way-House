//
//  LinkLibrary.h
//  WWH
//
//  Created by Michael Whang on 8/11/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkLibrary : NSObject

@property (nonatomic, strong) NSMutableDictionary *linkDictionary;

+ (LinkLibrary *)sharedLinkLibrary;

@end
