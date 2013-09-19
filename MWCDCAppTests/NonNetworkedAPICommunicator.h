//
//  NonNetworkedAPICommunicator.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "APICommunicator.h"

// A stubbed out version of the APICommunicator that allows
// setting response buffer directly (makes it easier to test
// URLConnection delegate methods)

@interface NonNetworkedAPICommunicator : APICommunicator

- (void)setResponseBufferContents:(NSData *)data;
- (NSData *)responseBufferContents;

@end
