//
//  MockPlaceDataManager.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "APICommunicatorDelegate.h"

@interface MockPlaceDataManager : NSObject <APICommunicatorDelegate>

@property (nonatomic, copy) NSError *fetchError;
@property (nonatomic, copy) NSString *responseJSON;

@end
