//
//  AnnotatedImageView.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/24/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotatedImageViewDelegate.h"
#import "SMCalloutView.h"

@interface AnnotatedImageView : UIView
{
    UIScrollView *_contentWrapperView;
 
    ImageAnnotationView *_selectedAnnotationView;
    NSArray *_annotationViews;
    
    SMCalloutView *_selectedAnnotationCallout;
}

@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
@property (nonatomic, copy) NSArray *annotations;

@property (nonatomic, weak) id<AnnotatedImageViewDelegate> delegate;

@end
