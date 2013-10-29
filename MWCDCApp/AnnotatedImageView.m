//
//  AnnotatedImageView.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/24/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "AnnotatedImageView.h"
#import <MapKit/MapKit.h>
#import "ImageAnnotation.h"

@interface InternalAnnotation : NSObject <MKAnnotation>
@property (nonatomic, copy) NSString *title;
@end

@implementation InternalAnnotation
@synthesize coordinate;
@end


@implementation AnnotatedImageView

NSString *annotationReuseIdentifier = @"ImageAnnotation";

- (id)init
{
    NSLog(@"in init");
    return [super init];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:_backgroundImageView];
        
        _annotationViews = [[NSArray alloc] init];
        NSLog(@"in code");
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:_backgroundImageView];
        
        _annotationViews = [[NSArray alloc] init];
        NSLog(@"in frame");
    }
    return self;
}

- (void)testTap:(id)sender
{
    NSLog(@"Hey dudez");
}

- (void)setImageAnnotations:(NSArray *)imageAnnotations
{
    // clear annotation subviews
    for (MKAnnotationView* view in _annotationViews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *_newMKAnnotationViews = [[NSMutableArray alloc] initWithCapacity:imageAnnotations.count];
    for (id<ImageAnnotation> annotation in imageAnnotations) {
        // create an MKAnnotation-compliant version of our annotation
        InternalAnnotation *mapAnnotation = [[InternalAnnotation alloc] init];
        mapAnnotation.title = annotation.title;
        MKPinAnnotationView *mapAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:mapAnnotation reuseIdentifier:annotationReuseIdentifier];
        
        // TODO: hook up callout view and add tap capabilities to it
// Experiments: not working yet
//        mapAnnotationView.enabled = YES;
//        mapAnnotationView.canShowCallout = YES;
//        mapAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        
//        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
//                                                 initWithTarget:self
//                                                 action:@selector(testTap:)];
//        [mapAnnotationView.rightCalloutAccessoryView addGestureRecognizer:tapRecognizer];


        // set the location of the subview
        [mapAnnotationView setCenter:annotation.coordinate];
        
        // keep track of the subview in our internal array
        [_newMKAnnotationViews addObject:mapAnnotationView];

        // officially register the subview
        [self addSubview:mapAnnotationView];
    }
    _annotationViews = [NSArray arrayWithArray:_newMKAnnotationViews];
    NSLog(@"been set with %d annotations", _annotationViews.count);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
