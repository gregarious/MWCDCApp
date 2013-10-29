//
//  PlaceCategoryPickerViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/24/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceCollectionViewController.h"
#import "PlaceCategoryPickerViewController.h"

@interface PlaceCategoryPickerViewController ()

@end

@implementation PlaceCategoryPickerViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.categories.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.categories[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *category = self.categories[row];
    [[self delegate] didPickCategory:category];
}

- (IBAction)closeButtonTapped:(id)sender {
    [[self delegate] didCancel];
}
@end
