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
@class ImageAnnotationView;

@protocol AnnotatedImageViewDelegate <NSObject>

@optional
- (ImageAnnotationView *)annotatedImageView:(AnnotatedImageView *)annotatedImageView
                          viewForAnnotation:(id<ImageAnnotation>)annotation;

- (void)    annotatedImageView:(AnnotatedImageView *)annotatedImageView
           imageAnnotationView:(ImageAnnotationView *)view
 calloutAccessoryControlTapped:(UIControl *)control;

@end
