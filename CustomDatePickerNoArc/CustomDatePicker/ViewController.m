//
//  ViewController.m
//  CustomDatePicker
//
//  Created by admin on 14.08.13.
//  Copyright (c) 2013 Zorin Evgeny. All rights reserved.
//

#import "ViewController.h"
#import "CustomDatePicker.h"

@interface ViewController ()
{
   IBOutlet CustomDatePicker* _customPicker;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _customPicker.backgroundColor = [UIColor grayColor];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
