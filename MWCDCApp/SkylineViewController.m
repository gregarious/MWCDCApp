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

@interface SkylineViewController ()

- (void)reloadData;
- (void)configureViews;

@end

@implementation SkylineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setOverlook:(Overlook *)overlook
{
    _overlook = overlook;
    [self configureViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataFetcher = [SkylineDataFetcher defaultFetcher];
    dataFetcher.delegate = self;
    
    dataStatus = SkylineViewDataStatusUninitialized;
    [self reloadData];
    
    annotatedImageView.backgroundImageView.image = self.overlook.skylineImage;
    [annotatedImageView.backgroundImageView sizeToFit];
    
    annotatedImageView.delegate = self;
    
    [self configureViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SkylineDataFetcherDelegate methods

- (void)didReceiveSkylinePoints:(NSArray *)points forOverlook:(NSInteger)overlookID
{
    skylinePoints = points;
    dataStatus = SkylineViewDataStatusInitialized;
    [self configureViews];
}

- (void)fetchingSkylinePointsFailedWithError:(NSError *)error
{
    // ignore the error if we already have data
    if (skylinePoints == nil) {
        dataStatus = SkylineViewDataStatusError;
    }
    [self configureViews];
}

#pragma mark - Segue methods

NSString * const interestPointSegueIdentifier = @"showInterestPointDetail";

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:interestPointSegueIdentifier]) {
        SkylinePoint *point = sender;
        InterestPointDetailViewController *detailVC = [segue destinationViewController];
        detailVC.interestPoint = point.interestPoint;
    }
}

#pragma mark - AnnotatedImageViewDelegate methods

- (ImageAnnotationView *)annotatedImageView:(AnnotatedImageView *)annotatedImageView
                          viewForAnnotation:(id<ImageAnnotation>)annotation
{
    ImageAnnotationView *view = [[ImageAnnotationView alloc] init];
    view.annotation = annotation;
    view.iconImage = [UIImage imageNamed:@"skyline_dot"];
    
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return view;
}

- (void)    annotatedImageView:(AnnotatedImageView *)annotatedImageView
           imageAnnotationView:(ImageAnnotationView *)view
 calloutAccessoryControlTapped:(UIControl *)control
{
    SkylinePoint *skylinePoint = (SkylinePoint *)view.annotation;
    [self performSegueWithIdentifier:interestPointSegueIdentifier sender:skylinePoint];
}

#pragma mark - Private methods

- (void)reloadData
{
    [dataFetcher fetchSkylinePoints:_overlook._id];
}
- (void)configureViews
{
    annotatedImageView.annotations = skylinePoints;
    self.navigationItem.title = self.overlook.name;
}


@end
