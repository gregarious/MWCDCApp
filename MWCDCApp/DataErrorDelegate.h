//
//  DataErrorDelegate.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 1/13/14.
//  Copyright (c) 2014 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataErrorDelegate <NSObject>

- (void)retryRequested;

@end
