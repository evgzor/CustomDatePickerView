//
//  ViewController.m
//  CustomDatePicker
//
//  Created by admin on 14.08.13.
//  Copyright (c) 2013 Zorin. All rights reserved.
//

#import "ViewController.h"
#import "CustomDatePicker.h"

@interface ViewController ()
{
   IBOutlet CustomDatePicker* _customPicker;
}
@end

@implementation ViewController

-(id)init
{
    INIT_BASE_VC
}
- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
