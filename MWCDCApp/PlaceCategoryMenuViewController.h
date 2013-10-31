//
//  PlaceCategoryMenuViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/31/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceCategoryMenuDelegate.h"

@interface PlaceCategoryMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *categories;
@property (nonatomic, copy) NSString *selectedCategory;

@property (nonatomic, weak) id <PlaceCategoryMenuDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)closeTapped:(id)sender;

@end
