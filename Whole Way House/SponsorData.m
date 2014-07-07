//
//  SponsorData.m
//  WWH
//
//  Created by Michael Whang on 6/15/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "SponsorData.h"

@implementation SponsorData

+ (NSArray *)allSponsors
{
    NSMutableArray *sponsorInformation = [@[] mutableCopy];
    
    NSDictionary *sponsor1 = @{    SPONSOR_NAME    : @"Quest Food Exchange",
                                   SPONSOR_TAGLINE : @"Reducing Hunger With Dignity",
                                   SPONSOR_URL     : @"http://www.questoutreach.org" };
    [sponsorInformation addObject:sponsor1];
    
    
    NSDictionary *sponsor2 = @{    SPONSOR_NAME    : @"Life Exchange Foundation",
                                   SPONSOR_TAGLINE : @"Providing life solutions for children and teens",
                                   SPONSOR_URL     : @"https://www.facebook.com/life.exchange.bc" };
    [sponsorInformation addObject:sponsor2];
    
    NSDictionary *sponsor3 = @{    SPONSOR_NAME    : @"Chop Shop",
                                   SPONSOR_TAGLINE : @"Progressive hairstyles in Coquitlam, Vancouver, Nelson",
                                   SPONSOR_URL     : @"http://www.chopshophair.com" };
    [sponsorInformation addObject:sponsor3];
    
    NSDictionary *sponsor4 = @{    SPONSOR_NAME    : @"Swiss Bakery",
                                   SPONSOR_TAGLINE : @"Artisan Bread Specialist",
                                   SPONSOR_URL     : @"http://swissbakery.ca" };
    [sponsorInformation addObject:sponsor4];
    
    NSDictionary *sponsor5 = @{    SPONSOR_NAME    : @"Executive Building Maintenance",
                                   SPONSOR_TAGLINE : @"Excellent quality green cleaning and sustainable services for an affordable price",
                                   SPONSOR_URL     : @"http://ebmjanitorial.ca" };
    [sponsorInformation addObject:sponsor5];
    
    NSDictionary *sponsor6 = @{    SPONSOR_NAME    : @"Union Gospel Mission",
                                   SPONSOR_TAGLINE : @"Feeding Hope. Changing Lives.",
                                   SPONSOR_URL     : @"http://www.ugm.ca" };
    [sponsorInformation addObject:sponsor6];
    
    NSDictionary *sponsor7 = @{    SPONSOR_NAME    : @"The Dirty Apron",
                                   SPONSOR_TAGLINE : @"Cooking school & delicatessen",
                                   SPONSOR_URL     : @"http://www.dirtyapron.com" };
    [sponsorInformation addObject:sponsor7];
    
    NSDictionary *sponsor8 = @{    SPONSOR_NAME    : @"Dunn Public Relations",
                                   SPONSOR_TAGLINE : @"Vancouver PR & Communications Firm",
                                   SPONSOR_URL     : @"http://www.dunnpr.com" };
    [sponsorInformation addObject:sponsor8];
    
    NSDictionary *sponsor9 = @{    SPONSOR_NAME    : @"RIF Moving",
                                   SPONSOR_TAGLINE : @"Small Moves & Delivery for BC",
                                   SPONSOR_URL     : @"http://www.rifmoving.com" };
    [sponsorInformation addObject:sponsor9];
    
    NSDictionary *sponsor10 = @{   SPONSOR_NAME    : @"Owen Bird Law Corporation",
                                   SPONSOR_TAGLINE : @"Commercial, property development, insurance, estates, family, contract and civil law",
                                   SPONSOR_URL     : @"http://www.owenbird.com" };
    [sponsorInformation addObject:sponsor10];
    
    NSDictionary *sponsor11 = @{   SPONSOR_NAME    : @"Coastal Church",
                                   SPONSOR_TAGLINE : @"Locations in Downtown Vancouver, Pitt Meadows, Strathcona",
                                   SPONSOR_URL     : @"http://www.coastalchurch.org" };
    [sponsorInformation addObject:sponsor11];
    
    NSDictionary *sponsor12 = @{   SPONSOR_NAME    : @"Lookout Society",
                                   SPONSOR_TAGLINE : @"Solutions to Homelessness",
                                   SPONSOR_URL     : @"http://lookoutsociety.ca" };
    [sponsorInformation addObject:sponsor12];
    
    NSDictionary *sponsor13 = @{   SPONSOR_NAME    : @"Pacific Powertech Inc.",
                                   SPONSOR_TAGLINE : @"Power System Specialists",
                                   SPONSOR_URL     : @"http://www.pacificpowertech.ca" };
    [sponsorInformation addObject:sponsor13];
    
    
    NSDictionary *sponsor14 = @{   SPONSOR_NAME    : @"The Home Depot Canada Foundation",
                                   SPONSOR_TAGLINE : @"Helping the housing needs of youth through renovation and repair projects and programs that provide access to safe, stable shelter and support services.",
                                   SPONSOR_URL     : @"http://www.homedepot.ca/foundation" };
    [sponsorInformation addObject:sponsor14];
    
    NSDictionary *sponsor15 = @{   SPONSOR_NAME    : @"Wolfgang Commercial Painters",
                                   SPONSOR_TAGLINE : @"Commercial and Strata Painting",
                                   SPONSOR_URL     : @"http://www.wolfgangpainters.com" };
    [sponsorInformation addObject:sponsor15];
    
    NSDictionary *sponsor16 = @{   SPONSOR_NAME    : @"General Paint",
                                   SPONSOR_TAGLINE : @"Our passion. Your results.",
                                   SPONSOR_URL     : @"http://www.generalpaint.com" };
    [sponsorInformation addObject:sponsor16];
    
    NSDictionary *sponsor17 = @{   SPONSOR_NAME    : @"Collage Collage",
                                   SPONSOR_TAGLINE : @"Inspired, clever and contemporary arts experiences for all",
                                   SPONSOR_URL     : @"http://collagecollage.ca" };
    [sponsorInformation addObject:sponsor17];
    
    NSDictionary *sponsor18 = @{   SPONSOR_NAME    : @"Kroma Artist's Acrylics",
                                   SPONSOR_TAGLINE : @"Small batch manufacturers of high quality artist's acrylics since 1970",
                                   SPONSOR_URL     : @"http://kromaacrylics.com" };
    [sponsorInformation addObject:sponsor18];
    
    return [sponsorInformation copy];
}

@end
