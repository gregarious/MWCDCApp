//
//  AnnotatedImageView.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/24/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "AnnotatedImageView.h"
#import "ImageAnnotationView.h"
#import "ImageAnnotation.h"
#import "SMCalloutView.h"

@interface AnnotatedImageView ()

// private methods related to managing tap events
- (void)annotationViewWasTapped:(UIGestureRecognizer *)gestureRecognizer;
- (void)calloutAccessoryTapped:(UIGestureRecognizer *)gestureRecognizer;
- (void)deselectAnnotation;

@end

@implementation AnnotatedImageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // TODO: either set this stuff up in IB, or use initWithFrame. also consider using constraints
        
        // TODO: this should be whole window, why is self.frame.size.width = 480?
        CGRect scrollFrame = CGRectMake(0, 0, self.bounds.size.width, [[UIScreen mainScreen] bounds].size.height);
        _contentWrapperView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(deselectAnnotation)]];

        _backgroundImageView = [[UIImageView alloc] init];
        [_contentWrapperView addSubview:_backgroundImageView];

        // TODO: remove debug position fix
        _contentWrapperView.contentOffset = CGPointMake(450, 0);
        
        [self addSubview:_contentWrapperView];
    }
    return self;
}

- (void)layoutSubviews
{
    // ensure background image size is correct
    [_backgroundImageView sizeToFit];
    
    CGSize sz = self.bounds.size;
    sz.width = _backgroundImageView.bounds.size.width;
    _contentWrapperView.contentSize = sz;
}

- (void)setAnnotations:(NSArray *)annotations
{
    // clear annotation subviews
    for (ImageAnnotationView* view in _annotationViews) {
        [view removeFromSuperview];
    }

    NSMutableArray *newMKAnnotationViews = [[NSMutableArray alloc] initWithCapacity:annotations.count];
    for (id<ImageAnnotation> annotation in annotations) {
        ImageAnnotationView *annotationView = [self.delegate annotatedImageView:self
                                                              viewForAnnotation:annotation];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(annotationViewWasTapped:)];
        [annotationView addGestureRecognizer:tapRecognizer];


        // set the location of the subview
        annotationView.center = CGPointMake(annotationView.annotation.coordinate.x, annotationView.annotation.coordinate.y);
        
        // keep track of the subview in our internal array
        [newMKAnnotationViews addObject:annotationView];

        // officially register the subview
        [_contentWrapperView addSubview:annotationView];
    }
    _annotationViews = [NSArray arrayWithArray:newMKAnnotationViews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)annotationViewWasTapped:(UIGestureRecognizer *)gestureRecognizer
{
    ImageAnnotationView *view = (ImageAnnotationView *)gestureRecognizer.view;
    
    SMCalloutView *callout = [SMCalloutView new];
    
    if ([view.annotation respondsToSelector:@selector(title)]) {
        callout.title = view.annotation.title;
    }
    if ([view.annotation respondsToSelector:@selector(subtitle)]) {
        callout.subtitle = view.annotation.subtitle;
    }
    
    if (view.leftCalloutAccessoryView) {
        callout.leftAccessoryView = view.leftCalloutAccessoryView;
        [callout.leftAccessoryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calloutAccessoryTapped:)]];
    }
    
    if (view.rightCalloutAccessoryView) {
        callout.rightAccessoryView = view.rightCalloutAccessoryView;
        [callout.rightAccessoryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calloutAccessoryTapped:)]];
    }
    
    [self deselectAnnotation];
    
    _selectedAnnotationView = view;
    _selectedAnnotationCallout = callout;

    [_selectedAnnotationCallout presentCalloutFromRect:view.frame
                                                inView:_contentWrapperView
                                     constrainedToView:self
                              permittedArrowDirections:SMCalloutArrowDirectionDown
                                              animated:SMCalloutAnimationStretch];

}

- (void)calloutAccessoryTapped:(UIGestureRecognizer *)gestureRecognizer
{
    // alert the delegate of the callout tap event
    // (we follow the MKAnnotationView standard of only responding if the accessory
    //  view is a UIControl, just cause)
    if ([gestureRecognizer.view isKindOfClass:UIControl.class]) {
        [self.delegate annotatedImageView:self
                      imageAnnotationView:_selectedAnnotationView
            calloutAccessoryControlTapped:(UIControl *)gestureRecognizer.view];
    }
}

- (void)deselectAnnotation
{
    [_selectedAnnotationCallout dismissCalloutAnimated:NO];
    _selectedAnnotationCallout = nil;
}

@end
