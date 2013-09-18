//
//  PlaceBuilder.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/18/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceBuilder : NSObject

- (NSArray *)placesFromJSON: (NSString *)objectNotation
                      error: (NSError **)error;



@end

extern NSString* const PlaceBuilderErrorDomain;

enum {
    PlaceBuilderInvalidJSONError,
    PlaceBuilderIllFormedDataError
};
