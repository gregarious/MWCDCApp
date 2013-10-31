//
//  PlaceCategoryMenuDelegate.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/24/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlaceCategoryMenuDelegate <NSObject>

- (void)didPickCategory:(NSString *)category;
- (void)didCancel;

@end
