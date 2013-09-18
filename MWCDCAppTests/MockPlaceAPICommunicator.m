//
//  MockPlaceAPICommunicator.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "MockPlaceAPICommunicator.h"

@implementation MockPlaceAPICommunicator
{
    BOOL _wasAskedToFetchQuestions;
}

- (BOOL)wasAskedToFetchQuestions {
    return _wasAskedToFetchQuestions;
}

- (void)searchForPlaces {
    _wasAskedToFetchQuestions = YES;
}

@end
