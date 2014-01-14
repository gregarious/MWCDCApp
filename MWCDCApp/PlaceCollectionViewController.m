//
//  PlaceCollectionViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/15/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceCollectionViewController.h"
#import "PlaceViewDataManager.h"
#import "PlaceDataStore.h"
#import "PlaceDetailViewController.h"
#import "PlaceTableViewCell.h"
#import "PlaceCategoryMenuViewController.h"
#import "Place.h"

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PlaceCollectionViewController ()
{
    BOOL isObservingManagerData;
}
- (void)closeModalPicker;
- (void)initializeCell:(PlaceTableViewCell *)cell withPlace:(Place *)place;
- (void)reloadContentViewData;

@end

@implementation PlaceCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set up background tap recognizer to clear search bar keyboard when active
    contentAreaTapRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissSearchKeyboard)];
    [contentAreaTapRecognizer setCancelsTouchesInView:YES];
    
    self.viewMode = PlaceCollectionViewModeTable;
    
    self.dataStatusView.layer.cornerRadius = 8;
    self.dataStatusView.layer.masksToBounds = YES;
    
    // create a data manager to store data once it is fetched
    dataManager = [PlaceViewDataManager new];
    // watch the manager's displayPlaces property for changes
    [dataManager addObserver:self
                  forKeyPath:@"displayPlaces"
                     options:NSKeyValueObservingOptionNew
                     context:NULL];

    // do the initial fetch of data
    self.dataStore.delegate = self;
    [self.dataStore fetchPlaces];
    
    [self showDataStatusWithMessage:@"Loading..." showLoadingIndicator:YES retryEnabled:NO];
    self.contentView.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

NSString * const placeCellReuseIdenitifier = @"PlaceCell";
NSString * const placeAnnotationReuseIdentifier = @"PlaceAnnotation";

- (void)setViewMode:(PlaceCollectionViewMode)viewMode
{
    _viewMode = viewMode;
    
    UIView *subview;
    if (viewMode == PlaceCollectionViewModeTable) {
        [mapView removeFromSuperview];
        
        tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // TODO: cache the nib at least
        UINib *nib = [UINib nibWithNibName:@"PlaceTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:placeCellReuseIdenitifier];
        
        [self.contentView addSubview:tableView];
        subview = tableView;
    }
    else {
        [tableView removeFromSuperview];
        
        mapView = [[MKMapView alloc] init];
        mapView.delegate = self;

        CLLocationCoordinate2D center;
        CLLocationDistance meterRadius;
        
        center = CLLocationCoordinate2DMake(40.432136, -80.012980),
        meterRadius = 2500;
        
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(center, meterRadius, meterRadius)];
        
        subview = mapView;
    }

    [self.contentView addSubview:subview];
    [self reloadContentViewData];

    // TODO: do a transition when toggling
    
    // Hack to force a layout problem during the first time the Places tab opens: the top
    // layout guide isn't set the first time this method is called, so we have to fake it
    // here. Probably related to the layout guide constraint hacks in Welcome/About VCs?
    NSNumber *topLayoutOffset;
    if (self.topLayoutGuide.length == 0.0) {
        topLayoutOffset = [NSNumber numberWithFloat:-64.0];
    }
    else {
        topLayoutOffset = [NSNumber numberWithFloat:0.0];
    }
    
    // set up constraints so subview takes up whole content view frame
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"subview": subview};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topLayoutOffset)-[subview]|"
                                                                          options:0
                                                                             metrics:@{@"topLayoutOffset": topLayoutOffset}
                                                                            views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.filterSearchBar.delegate = self;
    
    // set the filter category if it exists, else use "All Places"
    NSString *buttonTitle = dataManager.filterCategory ? dataManager.filterCategory : @"All Places";
    [self.categoryButton setTitle:buttonTitle forState:UIControlStateNormal];

    // iOS 6 styles
    if ([[[UIDevice currentDevice] systemVersion] intValue] < 7) {
        // shrink the size of the category button
        [self.categoryButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==30)]" options:0 metrics:nil views:@{@"button": self.categoryButton}]];
        // make the background color for the whole bar match the search bar background
        self.filterContainerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios6_searchbar_bkgd"]];
    }
    
    [super viewWillAppear:animated];
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPlaceDetail"]) {
        PlaceDetailViewController *detailVC = (PlaceDetailViewController *)[segue destinationViewController];
        [detailVC setPlace:(Place *)sender];
    }
    else if ([[segue identifier] isEqualToString:@"showCategoryMenu"]) {
        self.menuVC = (PlaceCategoryMenuViewController *)segue.destinationViewController;
        NSMutableArray *categories = [NSMutableArray arrayWithArray:dataManager.availableCategories];
        [categories insertObject:@"All Places" atIndex:0];
        self.menuVC.categories = categories;
        self.menuVC.selectedCategory = dataManager.filterCategory ? dataManager.filterCategory : @"All Places";
        self.menuVC.delegate = self;
    }
}

- (IBAction)toggleViews:(id)sender {
    if (self.viewMode == PlaceCollectionViewModeTable) {
        self.displayModeToggleButton.title = @"Map";
        self.viewMode = PlaceCollectionViewModeMap;
    }
    else {
        self.displayModeToggleButton.title = @"List";
        self.viewMode = PlaceCollectionViewModeTable;
    }
}


#pragma mark - PlaceDataFetcherDelegate protocol methods

- (void)didReceivePlaces:(NSArray *)places
{
    [self hideDataStatus];
    self.contentView.enabled = YES;
    dataManager.places = places;
}

- (void)fetchingPlacesFailedWithError:(NSError *)error
{
    [self showDataStatusWithMessage:@"Problem loading data" showLoadingIndicator:NO retryEnabled:YES];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    if (dataManager.displayPlaces) {
        return dataManager.displayPlaces.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert([indexPath row] < dataManager.displayPlaces.count);

    PlaceTableViewCell *cell = [tv dequeueReusableCellWithIdentifier:placeCellReuseIdenitifier];
    if (!cell) {
        cell = [[PlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:placeCellReuseIdenitifier];
    }
    
    Place *place = [dataManager.displayPlaces objectAtIndex:[indexPath row]];
    [self initializeCell:cell withPlace:place];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath.section == 0);

    Place *place = [dataManager.displayPlaces objectAtIndex:[indexPath row]];
    [self performSegueWithIdentifier:@"showPlaceDetail" sender:place];
}

#pragma mark - MKMapViewDelegate methods
- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id<MKAnnotation>)annotation
{
    // use the default annotation for current location
    if (annotation == mv.userLocation){
        return nil;
    }
    
    MKAnnotationView *view = [mv dequeueReusableAnnotationViewWithIdentifier:placeAnnotationReuseIdentifier];
    if (view == nil) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:placeAnnotationReuseIdentifier];
        view.enabled = YES;
        view.canShowCallout = YES;
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else {
        view.annotation = annotation;
    }
    
    return view;
}

- (void)mapView:(MKMapView *)mv annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // the annotation is the Place itself
    [self performSegueWithIdentifier:@"showPlaceDetail" sender:view.annotation];
}

#pragma mark - UISearchBarDelegate protocol
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    dataManager.filterQuery = searchText;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    // enable dismissal of the keyboard while blocking content area interaction
    [self.contentView addGestureRecognizer:contentAreaTapRecognizer];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    // free content area to receive taps again
    [self.contentView removeGestureRecognizer:contentAreaTapRecognizer];
    return YES;
}

- (void)dismissSearchKeyboard
{
    [self.filterSearchBar resignFirstResponder];
}

#pragma mark - Category picker related
- (void)didCancel
{
    [self closeModalPicker];
}

- (void)didPickCategory:(NSString *)category
{
    if ([category isEqualToString:@"All Places"]) {
        dataManager.filterCategory = nil;
    }
    else {
        dataManager.filterCategory = category;
    }
    
    [self.categoryButton setTitle:category forState:UIControlStateNormal];
    
    [self closeModalPicker];
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
    [self.dataStore fetchPlaces];
    [self showDataStatusWithMessage:@"Loading..." showLoadingIndicator:YES retryEnabled:NO];
    self.contentView.enabled = NO;
}

#pragma mark - Data manager KVO methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"displayPlaces"]) {
        [self reloadContentViewData];
    }
}

#pragma mark - Private utility methods

- (void)closeModalPicker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)initializeCell:(PlaceTableViewCell *)cell withPlace:(Place *)place
{
    cell.place = place;
    cell.nameLabel.text = place.name;
    cell.addressLabel.text = place.streetAddress;
    cell.categoryLabel.text = place.categoryLabel;
    
    cell.thumbnail.imageURL = [NSURL URLWithString:place.imageURLString];
    cell.thumbnail.crossfadeImages = NO;
}

- (void)reloadContentViewData
{
    if (tableView) {
        [tableView reloadData];
    }
    if (mapView) {
        [mapView removeAnnotations:mapView.annotations];
        [mapView addAnnotations:dataManager.displayPlaces];
    }
}

@end
