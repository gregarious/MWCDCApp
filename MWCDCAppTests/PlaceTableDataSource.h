//
//  PlaceTableViewDataSource.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Place;

@interface PlaceTableDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, copy) NSArray *places;

- (Place *)placeForIndexPath:(NSIndexPath *)indexPath;

@end
