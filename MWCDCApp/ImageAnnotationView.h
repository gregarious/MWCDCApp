//
//  ImageAnnotationView.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/30/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ImageAnnotation.h"

@interface ImageAnnotationView : UIView
{
    UIImageView *_iconImageView;
}

@property (nonatomic, strong) UIImage *iconImage;

@property (nonatomic, getter=isSelected) BOOL selected;

@property (nonatomic) CGPoint centerOffset;
@property (nonatomic) CGPoint calloutOffset;

@property (nonatomic, strong) UIView *leftCalloutAccessoryView;
@property (nonatomic, strong) UIView *rightCalloutAccessoryView;

@property (nonatomic, strong) id <ImageAnnotation> annotation;

@end
