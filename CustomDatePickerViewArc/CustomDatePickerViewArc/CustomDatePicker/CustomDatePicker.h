//
//  UICustomDatePicker.h
//  Seldon_2
//
//  Created by admin on 12.08.13.
//  Copyright (c) Zorin Evgeny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CustomDatePickerChangeCallback)(NSDate*);

@protocol CustomDatePickerDelegate;


@interface CustomDatePicker : UIView
{
    
    NSCalendar *_calendar;
    NSDate *_date;
    NSDate *_maximumDate;
    NSDate *_minimumDate;
    NSTimeZone *_timeZone;
    
    CustomDatePickerChangeCallback _customDatePickerChangeCallback;
    
}

@property(nonatomic, copy)   NSCalendar *calendar;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSDate *maximumDate;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSTimeZone *timeZone;

@property(nonatomic) id<CustomDatePickerDelegate> delegate;

@property(nonatomic, copy) CustomDatePickerChangeCallback customDatePickerChangeCallback;

-(id)initWithImageForDay:(UIImage*)dayImage andMonthImage:(UIImage*)monthImage andYearImage:(UIImage*)yearImage forRect:(CGRect)rect;

-(void)customDatePickerHasChangedCallBack:(CustomDatePickerChangeCallback)block;

@end

@protocol CustomDatePickerDelegate <NSObject>

@optional

-(void)datePickerDateChange:(CustomDatePicker*)piker forDate:(NSDate*) date;

@end