//
//  SkylineViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "SkylineViewController.h"
#import "Overlook.h"
#import "SkylinePoint.h"
#import "SkylineDataFetcher.h"
#import "InterestPointDetailViewController.h"
#import "AnnotatedImageView.h"
#import "ImageAnnotationView.h"
#import "SkylineView.h"
#import "MarkerView.h"

@interface SkylineViewController ()
{
    UIScrollView *scrollView;
    SkylineView *skylineView;
    UIView *detailView;
    NSMutableArray *detailViewConstraints;
}

// subview interaction methods
- (void)handleMarkerTap:(UITapGestureRecognizer *)sender;
- (void)showDetailPaneForMarkerView:(MarkerView *)markerView;
- (void)hideDetailPane;

// misc utility methods
- (void)reloadData;

@end

@implementation SkylineViewController

- (void)setOverlook:(Overlook *)overlook
{
    _overlook = overlook;
    self.navigationItem.title = self.overlook.name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataFetcher = [SkylineDataFetcher defaultFetcher];
    dataFetcher.delegate = self;
    
    dataStatus = SkylineViewDataStatusUninitialized;
    [self reloadData];
    
    /* Configure ScrollView to contain SkylineView */
    
    scrollView = [UIScrollView new];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.backgroundColor = [UIColor grayColor];
    
    // support hiding the detail pane when tapped
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(hideDetailPane)]];
    
    [self.view addSubview:scrollView];

    // fill entire contents of main view frame with scroll view
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"scrollView": scrollView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"scrollView": scrollView}]];
    
    /* Configure SkylineView (with no markers at the moment) */

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:self.overlook.skylineImage];
    
    skylineView = [[SkylineView alloc] initWithBackgroundView:backgroundView];
    [scrollView addSubview:skylineView];
    
    // attach scroll view's content view to all edges
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[skyline]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"skyline": skylineView}]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[skyline]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"skyline": skylineView}]];
    
    self.navigationItem.title = self.overlook.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SkylineDataFetcherDelegate methods

- (void)didReceiveSkylinePoints:(NSArray *)points forOverlook:(NSInteger)overlookID
{
    NSMutableArray *mvs = [NSMutableArray arrayWithCapacity:points.count];
    for (SkylinePoint *point in points) {
        [mvs addObject:[[MarkerView alloc] initWithPoint:point]];
    }
    skylineView.markerViews = mvs;
    dataStatus = SkylineViewDataStatusInitialized;
    NSLog(@"and we're back");
}

- (void)fetchingSkylinePointsFailedWithError:(NSError *)error
{
    // ignore the error if we already have data
    if (skylineView.markerViews == nil) {
        dataStatus = SkylineViewDataStatusError;
    }
}

#pragma mark - Segue methods

NSString * const interestPointSegueIdentifier = @"showInterestPointDetail";

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:interestPointSegueIdentifier]) {
        SkylinePoint *point = sender;
        InterestPointDetailViewController *detailVC = [segue destinationViewController];
        detailVC.interestPoint = point.interestPoint;
        detailVC.mapCoordinate = point.coordinate;
    }
}

#pragma mark - Subview interaction handling

- (void)handleMarkerTap:(UITapGestureRecognizer *)sender
{
    MarkerView *marker = (MarkerView *)sender.view;
    [self showDetailPaneForMarkerView:marker];
}

- (void)showDetailPaneForMarkerView:(MarkerView *)markerView
{
    detailView = [UIView new];
    detailView.backgroundColor = [UIColor whiteColor];
    
    /** configure name label **/
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, self.topLayoutGuide.length+20, 300, 30)];
    label.text = markerView.skylinePoint.interestPoint.name;
    [detailView addSubview:label];
    
    [self.view addSubview:detailView];
    
    /** configure swipe right close action **/
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(hideDetailPane)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [detailView addGestureRecognizer:swipeRecognizer];
    
    /** disable and readjust scroll view **/
    [scrollView setScrollEnabled:NO];
    
    CGFloat anchorX = markerView.skylinePoint.coordinate.x-((1.0/6.0)*self.view.frame.size.width)+.5*markerView.frame.size.width;
    // clamp content of scroll view to left edge
    if (anchorX < 0) {
        anchorX = 0.0;
    }
    // TODO: add logic to clamp scroll view content to right edge of visible part of view
    
    [scrollView setContentOffset:CGPointMake(anchorX, 0) animated:YES];
    
    
    /** set layout constraints for detail view **/
    detailView.translatesAutoresizingMaskIntoConstraints = NO;
    NSNumber *detailWidth = [NSNumber numberWithFloat:self.view.frame.size.width*2/3];
    
    detailViewConstraints = [NSMutableArray new];
    [detailViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailView]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"detailView": detailView}]];
    
    [detailViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[detailView(detailWidth)]|"
                                                                                       options:0
                                                                                       metrics:@{@"detailWidth": detailWidth}
                                                                                         views:@{@"detailView": detailView}]];
    [self.view addConstraints:detailViewConstraints];
    
    
    /** hide all markers that are not the one tapped **/
    for (MarkerView *m in skylineView.markerViews) {
        if (m != markerView) {
            m.hidden = YES;
        }
    }
}


- (void)hideDetailPane
{
    // remove detail view constraints
    if (detailViewConstraints != nil) {
        [self.view removeConstraints:detailViewConstraints];
        detailViewConstraints = nil;
    }
    
    // remove detail view
    [detailView removeFromSuperview];
    detailView = nil;
    
    // show all markers
    for (MarkerView *m in skylineView.markerViews) {
        m.hidden = NO;
    }
    
    // ensure scroll view snaps back to right edge
    if (scrollView.contentOffset.x > skylineView.frame.size.width - scrollView.frame.size.width) {
        CGPoint maxOffset = scrollView.contentOffset;
        maxOffset.x = skylineView.frame.size.width - scrollView.frame.size.width - 1;
        [scrollView setContentOffset:maxOffset animated:YES];
    }
    [scrollView setScrollEnabled:YES];
}

//#pragma mark - AnnotatedImageViewDelegate methods
//
//- (ImageAnnotationView *)annotatedImageView:(AnnotatedImageView *)annotatedImageView
//                          viewForAnnotation:(id<ImageAnnotation>)annotation
//{
//    ImageAnnotationView *view = [[ImageAnnotationView alloc] init];
//    view.annotation = annotation;
//    view.iconImage = [UIImage imageNamed:@"skylineMarker"];
//    
//    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//
//    return view;
//}
//
//- (void)    annotatedImageView:(AnnotatedImageView *)annotatedImageView
//           imageAnnotationView:(ImageAnnotationView *)view
// calloutAccessoryControlTapped:(UIControl *)control
//{
//    SkylinePoint *skylinePoint = (SkylinePoint *)view.annotation;
//    [self performSegueWithIdentifier:interestPointSegueIdentifier sender:skylinePoint];
//}
//

#pragma mark - Misc utility methods

- (void)reloadData
{
    [dataFetcher fetchSkylinePoints:_overlook._id];
}

@end
