//
//  PlaceTableViewDelegate.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PlaceTableDataSource;

@interface PlaceTableDelegate : NSObject <UITableViewDelegate>

@property (nonatomic, strong) PlaceTableDataSource *tableDataSource;

@end

extern NSString* const PlaceTableDidReceivePlaceNotification;