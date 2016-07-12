
//
//  Created by admin on 12.08.13.
//  Copyright (c) Zorin Evgeny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CustomDatePickerChangeCallback)(NSDate*);

@protocol CustomDatePickerDelegate;


@interface CustomDatePicker : UIView


@property(nonatomic,assign) id<CustomDatePickerDelegate> delegate;

@property(nonatomic, copy) CustomDatePickerChangeCallback customDatePickerChangeCallback;

-(id)initWithImageForDay:(UIImage*)dayImage andMonthImage:(UIImage*)monthImage andYearImage:(UIImage*)yearImage forRect:(CGRect)rect;

-(void)customDatePickerHasChangedCallBack:(CustomDatePickerChangeCallback)block;

@end

@protocol CustomDatePickerDelegate <NSObject>

@optional

-(void)datePickerDateChange:(CustomDatePicker*)piker forDate:(NSDate*) date;

@end