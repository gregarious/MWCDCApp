//
//  AnnotatedImageView.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/24/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotatedImageView : UIView
{
    NSArray *_annotationViews;
}

@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
@property (nonatomic, copy) NSArray *imageAnnotations;

- (void)testTap:(id)sender;

@end
