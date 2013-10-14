//
//  InterestPoint.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterestPoint : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *address;
@property (nonatomic, copy, readonly) NSString *description;

- (id)initWithName:(NSString *)name
           address:(NSString *)address
       description:(NSString *)description;

@end
