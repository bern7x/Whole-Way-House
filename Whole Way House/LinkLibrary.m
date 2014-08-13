//
//  LinkLibrary.m
//  WWH
//
//  Created by Michael Whang on 8/11/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "LinkLibrary.h"

@interface LinkLibrary ()

@end

@implementation LinkLibrary

- (NSMutableDictionary *)linkDictionary
{
    if (!_linkDictionary) {
        _linkDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _linkDictionary;
}

+ (LinkLibrary *)sharedLinkLibrary
{
    static LinkLibrary *linkLibrary = nil;
   
    @synchronized(self) {
        if (!linkLibrary) {
            linkLibrary = [[LinkLibrary alloc] init];
        }
    }
    
    return linkLibrary;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        // initialize stuff here
        PFQuery *query = [PFQuery queryWithClassName:@"Link"];
        [query whereKeyExists:@"name"];
        //[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            // download current links from Parse
            if (!error) {
                //NSLog(@"# of records: %d", [objects count]);
                for (PFObject *object in objects) {
                    [self.linkDictionary setObject:object[@"website"] forKey:object[@"name"]];
                }
                //NSLog(@"Log from LinkLibrary: %@", self.linkDictionary);
            }
        }];   
    }
    
    return self;
}



@end
