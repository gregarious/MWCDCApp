//
//  AnnotatedImageViewTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/24/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <MapKit/MapKit.h>
#import "AnnotatedImageView.h"
#import "AnnotatedImageViewDelegate.h"
#import "ImageAnnotation.h"

/**
 * Simple class conforming to ImageAnnotation protocol
 */
@interface TestAnnotation : NSObject <ImageAnnotation>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGPoint coordinate;
@end

@implementation TestAnnotation

@end

/*
 * Test category to make private variables public
 */
@implementation AnnotatedImageView (Test)
- (void)setAnnotationViews:(NSArray *)views {
    _annotationViews = views;
}
- (NSArray *)annotationViews {
    return _annotationViews;
}
@end


@interface AnnotatedImageViewTests : XCTestCase
{
    AnnotatedImageView *view;
    MKAnnotationView *firstAnnotationView;
    TestAnnotation *annotation;
}
@end

@implementation AnnotatedImageViewTests

/* Untested behaviors:
 * - Most everything: TODO
 */

- (void)setUp
{
    [super setUp];
    view = [[AnnotatedImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
}

- (void)tearDown
{
    view = nil;
    [super tearDown];
}

@end
