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
        // TODO: should this be getting set up in IB somehow?
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.userInteractionEnabled = YES;
        [_backgroundImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(deselectAnnotation)]];

        [self addSubview:_backgroundImageView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:_backgroundImageView];
    }
    return self;
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
        annotationView.center = annotationView.annotation.coordinate;
        
        // keep track of the subview in our internal array
        [newMKAnnotationViews addObject:annotationView];

        // officially register the subview
        [self addSubview:annotationView];
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
                                                inView:self
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
