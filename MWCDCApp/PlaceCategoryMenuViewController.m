//
//  PlaceCategoryMenuViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/31/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceCategoryMenuViewController.h"

@interface PlaceCategoryMenuViewController ()

@end

@implementation PlaceCategoryMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data handling

- (void)setCategories:(NSArray *)categories
{
    _categories = [categories copy];
    [self.tableView reloadData];
}

- (void)setSelectedCategory:(NSString *)selectedCategory
{
    _selectedCategory = selectedCategory;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *category = self.categories[indexPath.row];
    if ([category isEqualToString:self.selectedCategory]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = self.categories[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newSelected = self.categories[indexPath.row];
    self.selectedCategory = newSelected;
    
    [self.delegate didPickCategory:self.categories[indexPath.row]];
}

- (IBAction)closeTapped:(id)sender {
    [self.delegate didCancel];
}
@end
