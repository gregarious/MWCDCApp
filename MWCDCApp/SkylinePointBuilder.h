//
//  SkylinePointBuilder.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkylinePointBuilder : NSObject

- (NSArray *)dataFromJSON:(NSString *)objectNotation
                    error:(NSError**)error;

@end

extern NSString* const SkylinePointBuilderErrorDomain;

enum {
    SkylinePointBuilderInvalidJSONError,
    SkylinePointBuilderIllFormedDataError
};
