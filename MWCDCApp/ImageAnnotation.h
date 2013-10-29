//
//  ImageAnnotation.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/29/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageAnnotation <NSObject>

@required
- (CGPoint)coordinate;

@optional
- (NSString *)title;
- (NSString *)subtitle;

@end
