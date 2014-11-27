//
//  ViewController.h
//  CustomDatePicker
//
//  Created by admin on 14.08.13.
//  Copyright (c) 2013 Zorin Evgeny. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INIT_BASE_VC NSString* form =  NSStringFromClass(self.class); \
if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad))\
{\
self = [super initWithNibName:[NSString stringWithFormat:@"%@%@",form,@"_iPad"] bundle:nil];\
}\
else\
{\
self = [super initWithNibName:[NSString stringWithFormat:@"%@%@",form,@"_iPhone"] bundle:nil];\
} \
return self;

@interface ViewController : UIViewController

@end
