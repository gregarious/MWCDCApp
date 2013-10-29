//
//  AnnotatedImageViewTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/24/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MapKit/MapKit.h>
#import "AnnotatedImageView.h"
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
- (NSArray *)annotationViews {
    return _annotationViews;
}
@end


@interface AnnotatedImageViewTests : XCTestCase
{
    AnnotatedImageView *view;
    TestAnnotation *annotation;
}
@end

@implementation AnnotatedImageViewTests

/* Untested behaviors:
 * - subviews (background, annotation) are stored in officially registered subviews array
 *
 */

- (void)setUp
{
    [super setUp];
    view = [[AnnotatedImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    annotation = [[TestAnnotation alloc] init];
    annotation.title = @"Big Building";
    annotation.coordinate = CGPointMake(50, 60);
    
    view.imageAnnotations = @[annotation];
}

- (void)tearDown
{
    view = nil;
    [super tearDown];
}

- (void)testShouldCreateMKAnnotationViewsForEachImageAnnotation
{
    XCTAssertEqual(view.annotationViews.count, (NSUInteger)1);
}

- (void)testShouldCreateMKAnnotationViewsWithCorrectTitles
{
    MKAnnotationView *annView = view.annotationViews[0];
    XCTAssertEqualObjects(annView.annotation.title, @"Big Building");
}

- (void)testShouldAssignCoordinatesToMKAnnotationViews
{
    MKAnnotationView *annView = view.annotationViews[0];
    XCTAssertEqualWithAccuracy(annView.center.x, 50, 1e-6);
    XCTAssertEqualWithAccuracy(annView.center.y, 60, 1e-6);
}

- (void)testShouldNotAssignCoordinatesToMKAnnotations
{
    // not strictly necessary, but helps reenforce the fact that the MKAnnotation
    // coordinates have nothing to do with their placement in the view
    MKAnnotationView *annView = view.annotationViews[0];
    XCTAssertEqualWithAccuracy(annView.annotation.coordinate.latitude, 0, 1e-6);
    XCTAssertEqualWithAccuracy(annView.annotation.coordinate.latitude, 0, 1e-6);
}

- (void)testShouldContainBackgroundImageViewAsSubview
{
    XCTAssertTrue([view.subviews indexOfObject:view.backgroundImageView] != NSNotFound, @"ensure background image is officially registered as a subview");
}

- (void)testShouldContainAnnotationViewAsSubview
{
    MKAnnotationView *annView = view.annotationViews[0];
    XCTAssertTrue([view.subviews indexOfObject:annView] != NSNotFound, @"ensure background image is officially registered as a subview");
}

@end
