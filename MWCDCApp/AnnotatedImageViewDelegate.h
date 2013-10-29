//
//  AnnotatedImageViewDelegate.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/29/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageAnnotation.h"

@class AnnotatedImageView;

@protocol AnnotatedImageViewDelegate <NSObject>

- (void)annotatedImageView:(AnnotatedImageView *)annotatedImageView
                annotation:(id <ImageAnnotation>);

@end
