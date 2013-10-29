//
//  PlaceCategoryPickerViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/24/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceCategoryPickerDelegate.h"

@interface PlaceCategoryPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<PlaceCategoryPickerDelegate> delegate;
@property (nonatomic, copy) NSArray *categories;

- (IBAction)closeButtonTapped:(id)sender;

@end
