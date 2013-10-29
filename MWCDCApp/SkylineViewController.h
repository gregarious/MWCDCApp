//
//  SkylineViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkylineDataFetcherDelegate.h"

@class Overlook;
@class SkylineDataFetcher;
@class AnnotatedImageView;

typedef NS_ENUM(NSUInteger, SkylineViewDataStatus) {
    SkylineViewDataStatusUninitialized,
    SkylineViewDataStatusInitialized,
    SkylineViewDataStatusError
};

@interface SkylineViewController : UIViewController <SkylineDataFetcherDelegate>
{
    SkylineDataFetcher *dataFetcher;
    NSArray *skylinePoints;
    
    SkylineViewDataStatus dataStatus;
    IBOutlet AnnotatedImageView *annotatedImageView;
}

@property (nonatomic, strong) Overlook *overlook;

@end
