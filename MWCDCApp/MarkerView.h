//
//  MarkerView.h
//  SkylinePOC
//
//  Created by Greg Nicholas on 11/22/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SkylinePoint;

@interface MarkerView : UIImageView

@property (nonatomic, strong, readonly) SkylinePoint *skylinePoint;

- (id)initWithPoint:(SkylinePoint *)skylinePoint;

@end
