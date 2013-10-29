//
//  SkylinePointBuilder.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "SkylinePointBuilder.h"
#import "SkylinePoint.h"
#import "InterestPoint.h"

@interface SkylinePointBuilder ()
- (SkylinePoint *)buildSkylinePointFromDictionary:(NSDictionary *)dataDict;
- (void)setError:(NSError **)error withCode:(NSInteger)code;
@end

@implementation SkylinePointBuilder

- (NSArray *)dataFromJSON:(NSString *)objectNotation
                    error:(NSError**)error
{
    NSParameterAssert(objectNotation != nil);
    
    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError = nil;
    
    id jsonDict = [NSJSONSerialization JSONObjectWithData:unicodeNotation
                                                  options:0
                                                    error:&localError];
    if (jsonDict == nil) {
        // if nil, input was invalid JSON
        [self setError:error withCode:SkylinePointBuilderInvalidJSONError];
        return nil;
    }
    else if ([jsonDict isKindOfClass:[NSArray class]]) {
        // if result is an array, fail because we expected an dict with "interest_points" key
        [self setError:error withCode:SkylinePointBuilderIllFormedDataError];
        return nil;
    }
    
    NSArray *skylinePointDataArray = [jsonDict objectForKey:@"interest_points"];
    if (skylinePointDataArray == nil) {
        // if interest_points key didn't exist, fail
        [self setError:error withCode:SkylinePointBuilderIllFormedDataError];
        return nil;
    }
    
    NSMutableArray *skylinePointArray = [[NSMutableArray alloc] initWithCapacity:[skylinePointDataArray count]];
    
    for (int i = 0; i < [skylinePointDataArray count]; ++i) {
        SkylinePoint *skylinePoint = [self buildSkylinePointFromDictionary:skylinePointDataArray[i]];
        
        // nil will be returned if JSON is missing a required property
        if (skylinePoint == nil) {
            [skylinePointArray addObject:[NSNull null]];
        }
        else {
            [skylinePointArray addObject:skylinePoint];
        }
    }
    
    return [skylinePointArray copy];
}

/** private **/
- (SkylinePoint *)buildSkylinePointFromDictionary:(NSDictionary *)dict {
    if (dict[@"name"] == nil ||
        dict[@"address"] == nil ||
        dict[@"description"] == nil ||
        dict[@"x"] == nil ||
        dict[@"y"] == nil) {
        
        return nil;
    }
    
    InterestPoint *interestPoint = [[InterestPoint alloc] initWithName:dict[@"name"]
                                                               address:dict[@"address"]
                                                           description:dict[@"description"]];

    return [[SkylinePoint alloc] initWithInterestPoint:interestPoint
                                            coordinate:CGPointMake([dict[@"x"] doubleValue],
                                                                   [dict[@"y"] doubleValue])];
}

- (void)setError:(NSError **)error withCode:(NSInteger)code {
    if (error) {
        *error = [NSError errorWithDomain:SkylinePointBuilderErrorDomain
                                     code:code
                                 userInfo:nil];
    }
}

@end

NSString* const SkylinePointBuilderErrorDomain = @"SkylinePointBuilderErrorDomain";
