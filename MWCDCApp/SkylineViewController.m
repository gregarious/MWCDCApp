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
#import "SkylineDataStore.h"
#import "SkylineView.h"
#import "MarkerView.h"
#import "InterestPointDetailView.h"

CGFloat DETAIL_VIEW_RELATIVE_WIDTH = 2.0/3.0;
CGFloat DEFAULT_MARKER_ALPHA = 0.7;

@interface SkylineViewController ()
{
    UIScrollView *scrollView;
    SkylineView *skylineView;
    InterestPointDetailView *detailView;
 
    NSMutableArray *detailViewConstraints;
    NSLayoutConstraint *detailViewTrailingEdgeConstraint;
    NSNumber *detailViewWidth;
}

// subview interaction methods
- (void)handleMarkerTap:(UITapGestureRecognizer *)sender;
- (void)showDetailPaneForMarkerView:(MarkerView *)markerView;
- (void)hideDetailPane;

// rotation-based display helpers
- (void)setViewContentForOrientation:(UIInterfaceOrientation)orientation;

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
    dataFetcher = [SkylineDataStore defaultFetcher];
    dataFetcher.delegate = self;
    
    [self reloadData];
    
    self.dataStatusView.layer.cornerRadius = 8;
    self.dataStatusView.layer.masksToBounds = YES;
    
    // ensure rotation message is always on top
    self.rotationMessageLabel.layer.zPosition = 100;
    
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

- (void)viewWillAppear:(BOOL)animated
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self setViewContentForOrientation:orientation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    // disallow transition from landscape to portrait
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setViewContentForOrientation:toInterfaceOrientation];
}

- (void)setViewContentForOrientation:(UIInterfaceOrientation)orientation
{
    // if device is in portrait mode, hide the content so the rotate message underneath shows
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight) {
        self.rotationMessageLabel.hidden = YES;
        scrollView.hidden = NO;
    }
    else {
        self.rotationMessageLabel.hidden = NO;
        scrollView.hidden = YES;
    }
}

#pragma mark - SkylineDataStoreDelegate methods

- (void)didReceiveSkylinePoints:(NSArray *)points forOverlook:(NSInteger)overlookID
{
    NSMutableArray *mvs = [NSMutableArray arrayWithCapacity:points.count];
    for (SkylinePoint *point in points) {
        MarkerView *mv = [[MarkerView alloc] initWithPoint:point];
        [mv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(handleMarkerTap:)]];
        [mvs addObject:mv];
        
        // start with invisible, disabled markers. animation below will enable them.
        mv.alpha = 0.0;
        mv.userInteractionEnabled = NO;
    }
    
    skylineView.markerViews = mvs;
    
    // enable and fade in the markers
    [UIView animateWithDuration:0.5
            animations:^{
                for (MarkerView *mv in skylineView.markerViews) {
                    mv.alpha = DEFAULT_MARKER_ALPHA;
                }
            }
            completion:^(BOOL finished) {
                for (MarkerView *mv in skylineView.markerViews) {
                    mv.userInteractionEnabled = YES;
                }
            }
     ];
    
    [self hideDataStatus];
}

- (void)fetchingSkylinePointsFailedWithError:(NSError *)error
{
    if (skylineView.markerViews == nil) {
        [self showDataStatusWithMessage:@"Problem loading data"
                   showLoadingIndicator:NO
                           retryEnabled:YES];
        [self.view bringSubviewToFront:self.dataStatusView];
    }
}

#pragma mark - Subview interaction handling

- (void)handleMarkerTap:(UITapGestureRecognizer *)sender
{
    MarkerView *mv = (MarkerView *)sender.view;
    [self showDetailPaneForMarkerView:mv];
}

- (void)showDetailPaneForMarkerView:(MarkerView *)markerView
{
    detailView = [[NSBundle mainBundle] loadNibNamed:@"InterestPointDetailView"
                                  owner:self
                                options:nil][0];
    detailView.alpha = DEFAULT_MARKER_ALPHA;
    
    InterestPoint *ip = markerView.skylinePoint.interestPoint;
    detailView.nameLabel.text = ip.name;
    detailView.addressLabel.text = ip.address;
    detailView.descriptionLabel.text = ip.description;
    
    [self.view addSubview:detailView];
    
    /** configure swipe right close action **/
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(hideDetailPane)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [detailView addGestureRecognizer:swipeRecognizer];
    
    /** disable and pan scroll view **/
    [scrollView setScrollEnabled:NO];
    
    // determine where the scroll view's content view needs to move to be centered in
    // the left pane (this value gets set in the animation block below)
    float unobscuredViewCenterX = ((1.0-DETAIL_VIEW_RELATIVE_WIDTH)/2.0)*self.view.frame.size.width;
    CGFloat anchorX = markerView.skylinePoint.coordinate.x-unobscuredViewCenterX;
    // clamp content of scroll view to left edge
    if (anchorX < 0) {
        anchorX = 0.0;
    }
    
    /** disable all markers from being tapped and highlight selected one **/
    for (MarkerView *mv in skylineView.markerViews) {
        mv.userInteractionEnabled = NO;
    }
    markerView.highlighted = YES;
    
    /** set layout constraints for detail view **/
    detailView.translatesAutoresizingMaskIntoConstraints = NO;
    
    detailViewConstraints = [NSMutableArray new];
    NSNumber *topLayoutSpace;
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        topLayoutSpace = [NSNumber numberWithFloat:self.topLayoutGuide.length];
    }
    else {
        topLayoutSpace = [NSNumber numberWithInt:0];
    }
    [detailViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topLayout-[detailView]|"
                                                                                       options:0
                                                                                       metrics:@{@"topLayout": topLayoutSpace}
                                                                                         views:@{@"detailView": detailView}]];
    
    detailViewWidth = [NSNumber numberWithFloat:self.view.frame.size.width*DETAIL_VIEW_RELATIVE_WIDTH];
    [detailViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[detailView(detailWidth)]"
                                                                                       options:0
                                                                                       metrics:@{@"detailWidth": detailViewWidth}
                                                                                         views:@{@"detailView": detailView}]];

    // this is the constraint whose change will be animated to enable the slide animation
    detailViewTrailingEdgeConstraint = [NSLayoutConstraint constraintWithItem:detailView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0
                                                                     constant:[detailViewWidth floatValue]];
    [detailViewConstraints addObject:detailViewTrailingEdgeConstraint];
    
    // layout now so animation block has something to change
    [self.view addConstraints:detailViewConstraints];
    [self.view layoutIfNeeded];

    // set final location for animation block to use
    detailViewTrailingEdgeConstraint.constant = 0;
    
    /** Pane opening animations include:
      * - sliding detail view onto screen
      * - fading out other markers
      * - moving scroll view content to center marker in left panel
     */
    [UIView animateWithDuration:0.33 animations:^{
        [self.view layoutIfNeeded];
        for (MarkerView *m in skylineView.markerViews) {
            if (m != markerView) {
                m.alpha = 0;
            }
        }
        [scrollView setContentOffset:CGPointMake(anchorX, 0)];
    }];
}


- (void)hideDetailPane
{
    // move the detail view completely off-screen
    detailViewTrailingEdgeConstraint.constant = [detailViewWidth floatValue];
    
    // reset all highlighting
    for (MarkerView *mv in skylineView.markerViews) {
        mv.highlighted = NO;
    }
    
    /** Pane closing animations include:
      * - sliding detail view off screen
      * - fading in all markers
      * - sliding scroll view content back if its edge escaped the
      *    right part of the screen
      *
      * After animation completes, detail view is destroyed and marker 
      *  interaction is reenabled.
     */
    [UIView animateWithDuration:0.33
            animations:^{
                // slide view right and fade in markers
                [self.view layoutIfNeeded];
                for (MarkerView *m in skylineView.markerViews) {
                    m.alpha = DEFAULT_MARKER_ALPHA;
                }
                // if scroll view is scrolled to the right of the content, ensure it snaps back
                if (scrollView.contentOffset.x > skylineView.frame.size.width - scrollView.frame.size.width) {
                    CGPoint maxOffset = scrollView.contentOffset;
                    maxOffset.x = skylineView.frame.size.width - scrollView.frame.size.width - 1;
                    [scrollView setContentOffset:maxOffset];
                }
            }
            completion:^(BOOL finished){
                // clean up and destroy detail view
                if (detailViewConstraints != nil) {
                    [self.view removeConstraints:detailViewConstraints];
                    detailViewConstraints = nil;
                }
                [detailView removeFromSuperview];
                detailView = nil;
                
                // also, allow interaction with scroll view and markers again
                for (MarkerView *m in skylineView.markerViews) {
                    m.userInteractionEnabled = YES;
                }
                [scrollView setScrollEnabled:YES];
            }
     ];
}

#pragma mark - Data status view methods

- (void)showDataStatusWithMessage:(NSString *)message showLoadingIndicator:(BOOL)shouldShowLoadingIndicator retryEnabled:(BOOL)shouldEnableRetry
{
    self.dataStatusLabel.text = message;
    if (shouldShowLoadingIndicator) {
        [self.dataStatusLoadingIndicator startAnimating];
    }
    else {
        [self.dataStatusLoadingIndicator stopAnimating];
    }
    
    self.dataStatusRetryButton.enabled = shouldEnableRetry;
    self.dataStatusRetryButton.hidden = !shouldEnableRetry;
    
    self.dataStatusView.hidden = NO;
    
    [self.dataStatusView layoutIfNeeded];
}

- (void)hideDataStatus
{
    self.dataStatusView.hidden = YES;
}

- (void)retryDataLoad:(id)sender
{
    [self reloadData];
}

#pragma mark - Misc utility methods

- (void)reloadData
{
    [dataFetcher fetchSkylinePoints:_overlook._id];
    [self showDataStatusWithMessage:@"Loading..."
               showLoadingIndicator:YES
                       retryEnabled:NO];
    [self.view bringSubviewToFront:self.dataStatusView];

}

@end
