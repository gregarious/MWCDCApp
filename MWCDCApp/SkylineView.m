//
//  SkylineView.m
//  SkylinePOC
//
//  Created by Greg Nicholas on 11/22/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "SkylineView.h"
#import "MarkerView.h"
#import "SkylinePoint.h"

@interface SkylineView ()
{
    NSMutableArray *backgroundConstraints;
    NSMutableArray *markerConstraints;
}
@end

@implementation SkylineView

- (id)initWithBackgroundView:(UIImageView *)backgroundView
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _backgroundView = backgroundView;
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_backgroundView];
    }
    return self;
}

- (void)setMarkerViews:(NSArray *)markerViews
{
    // if marker views have already been set up, remove them from the hierarchy
    if (self.markerViews != nil) {
        for (MarkerView* mv in self.markerViews) {
            [mv removeFromSuperview];
        }
    }

    // add all the subviews
    _markerViews = markerViews;
    for (MarkerView* mv in self.markerViews) {
        mv.alpha = .6;
        [self addSubview:mv];
    }
    
    // reset the constraints
    [self removeConstraints:markerConstraints];
    markerConstraints = nil;
    [self setMarkerConstraints];
}

- (void)setBackgroundConstraints
{
    if (backgroundConstraints == nil) {
        backgroundConstraints = [NSMutableArray array];
        
        // attach image to top & left edges (also set view's width/height by attaching to bottom & right edges)
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[background]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"background": self.backgroundView}];
        [backgroundConstraints addObjectsFromArray:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[background]|"
                                                              options:0
                                                              metrics:nil
                                                                views:@{@"background": self.backgroundView}];
        [backgroundConstraints addObjectsFromArray:constraints];
        [self addConstraints:backgroundConstraints];
    }
}

- (void)setMarkerConstraints
{
    if (markerConstraints == nil) {
        markerConstraints = [NSMutableArray array];
        // add x,y position for markers
        for (MarkerView* mv in self.markerViews) {
            mv.translatesAutoresizingMaskIntoConstraints = NO;

            CGFloat centerOffsetX = mv.image.size.width/2.0;
            CGFloat centerOffsetY = mv.image.size.height/2.0;
            NSNumber *xPos = [NSNumber numberWithFloat:mv.skylinePoint.coordinate.x-centerOffsetX];
            NSNumber *yPos = [NSNumber numberWithFloat:mv.skylinePoint.coordinate.y-centerOffsetY];
            [markerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-xPos-[marker]"
                                                                                          options:0
                                                                                          metrics:@{@"xPos": xPos}
                                                                                            views:@{@"marker": mv}]];
            [markerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-yPos-[marker]"
                                                                                          options:0
                                                                                          metrics:@{@"yPos": yPos}
                                                                                            views:@{@"marker": mv}]];
        }
        [self addConstraints:markerConstraints];
    }
}

- (void)updateConstraints
{
    [self setBackgroundConstraints];
    [self setMarkerConstraints];
    
    [super updateConstraints];
}

@end
