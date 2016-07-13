//
//  UICustomDatePicker.m
//  Seldon_2
//
//  Created by admin on 12.08.13.
//  Copyright (c) 2013 Zorin Evgeny. All rights reserved.
//

#import "CustomDatePicker.h"
#import "CustomPickerView.h"

static const NSInteger kMinYearValue = 1900;

@interface  CustomDatePicker() <CustomPickerControllerDelegate>
{
    CustomPickerView* _dayPicker;
    CustomPickerView* _yearPicker;
    CustomPickerView* _mounthPicker;
    
    NSUInteger _year;
    
    NSUInteger _minYear;
        
    NSCalendar *_calendar;
    NSDate *_date;
    NSDate *_maximumDate;
    NSDate *_minimumDate;
    NSTimeZone *_timeZone;
        
    CustomDatePickerChangeCallback _customDatePickerChangeCallback;
}

@property(strong, strong)    UIImage* dayImage;
@property(strong, strong)    UIImage* monthImage;
@property(strong, strong)    UIImage* yearImage;

@property(nonatomic, copy)   NSCalendar *calendar;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSDate *maximumDate;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSTimeZone *timeZone;

-(void) defaultDataInit;
 
@end

@implementation CustomDatePicker

@synthesize dayImage = _dayImage;
@synthesize monthImage = _monthImage;
@synthesize yearImage = _yearImage;
@synthesize delegate;

#pragma mark - Init functions

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self defaultDataInit];
    }
    return self;

}


-(id)init
{
    if (self = [super init])
    {
        [self defaultDataInit];
    }
    
    return self;
}
-(id)initWithImageForDay:(UIImage*)dayImage andMonthImage:(UIImage*)monthImage andYearImage:(UIImage*)yearImage forRect:(CGRect)rect
{
    self = [self initWithFrame:rect];
    
    if (self)
    {
        _dayImage = dayImage;
        _monthImage = monthImage;
        _yearImage = yearImage;
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultDataInit];
        
    }
    return self;
}

-(void) defaultDataInit
{
    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 250, 50);
    _dayImage = [UIImage imageNamed:@"day"];
    _monthImage = [UIImage imageNamed:@"month"];
    _yearImage = [UIImage imageNamed:@"year"];
    
    _dayPicker = nil;
    _yearPicker = nil;
    _mounthPicker = nil;
    
    _year = kMinYearValue;
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    _date = [NSDate date];
    _minYear = kMinYearValue;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear: kMinYearValue];
    
    _minimumDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    _maximumDate = [NSDate date];
    
}


#pragma mark prepare View
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _dayImage.size.width + _monthImage.size.width + _yearImage.size.width - 2 * kTableRectOfset, _dayImage.size.height);
    
    if (_maximumDate < _date)
    {
        _date = _maximumDate;
    }
    
    NSDateComponents *components = [_calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:_maximumDate];
    
    NSInteger year = _year = [components year];
    
    NSMutableArray* years = [NSMutableArray array];

    _minYear = [[_calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:_minimumDate] year];
    
    for (NSUInteger i = _minYear; i<=year; i++)
    {
        [years addObject:[NSString stringWithFormat:@"%lu",(unsigned long)i]];
    }
    
    _yearPicker= [[CustomPickerView alloc] initWithFrame:CGRectMake(_dayImage.size.width + _monthImage.size.width-2 * kTableRectOfset, 0, _yearImage.size.width, _yearImage.size.height) background:_yearImage itemVerticalOffset:0.0f andData:years];
    _yearPicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    //[_yearPicker setDataIndex:_date.y];
    _yearPicker.delegate = self;
    
    NSDateFormatter *df = [NSDateFormatter new];
    // change locale if the standard is not what you want
    
    NSArray *monthNames = [df standaloneMonthSymbols];
    _mounthPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(_dayImage.size.width - kTableRectOfset , 0, _monthImage.size.width, _monthImage.size.height)background:_monthImage itemVerticalOffset:0.0f andData:monthNames];
    _mounthPicker.delegate = self;
    _mounthPicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init];

    
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
                              inUnit:NSMonthCalendarUnit
                             forDate:[cal dateFromComponents:comps]];
    NSLog(@"%lu", (unsigned long)range.length);
    
    NSMutableArray* days = [NSMutableArray array];
    
    for (int i= 1; i<=range.length; i++)
    {
        [days addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _dayPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 0, _dayImage.size.width, _dayImage.size.height) background:_dayImage itemVerticalOffset:0.0f andData:days];
    _dayPicker.delegate = self;
    
    _dayPicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [_dayPicker retrieveCustomPickerViewControllerDidSpinCallback:^(NSInteger day)
    {
        NSLog(@"Day %ld",(long)day);
    }];
    
    
    NSDateComponents *comp = [_calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:_date];
    
    year = [comp year];
    NSInteger month = [comp month];
    NSInteger day = [comp day];
    
    [_yearPicker setDataIndex:year - _minYear];
    [_mounthPicker setDataIndex:month - 1];
    [_dayPicker setDataIndex:day - 1];
    
    [self addSubview:_dayPicker];
    [self addSubview:_mounthPicker];
    [self addSubview:_yearPicker];
    
    [_yearPicker retrieveCustomPickerViewControllerDidSpinCallback:^(NSInteger year)
    {
        _year = _minYear - 1 + year;
        NSLog(@"Year %ld",(long)_year);
    }];
    
    [_mounthPicker retrieveCustomPickerViewControllerDidSpinCallback:^(NSInteger month)
    {
        NSCalendar* cal = [NSCalendar currentCalendar];
        
         NSDateComponents* comps = components;
        [comps setMonth:month];
        [comps setYear:_year];
        
        NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:[cal dateFromComponents:comps]];
        
        NSMutableArray* days = [NSMutableArray array];
        
        for (int i= 1; i<=range.length; i++)
        {
            [days addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _dayPicker.data4Rows = days;
        
        NSLog(@"Month %ld",(long)month);
        
    }];
    
}

#pragma mark - memory managment

- (void)dealloc
{
    _dayPicker = nil;
    _yearPicker = nil;
    _yearPicker = nil;
    _monthImage = nil;
    _monthImage = nil;
    
    _dayImage = nil;
    _yearImage = nil;
    _monthImage = nil;
    _calendar = nil;
}

#pragma mark - callback functions

-(void)customDatePickerHasChangedCallBack:(CustomDatePickerChangeCallback)block
{
    self.customDatePickerChangeCallback = block;
}
#pragma mark UICustomPickerConrol Delegate

- (void)pickerControllerDidSpin:(CustomPickerView *)controller;
{

}

- (void)pickerController:(CustomPickerView *)dial didSnapToString:(NSString *)string
{
    NSLog(@"index %ld",(long)dial.selectedIndex);
    if (_customDatePickerChangeCallback)
    {
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:1+_dayPicker.selectedIndex];
        [comps setMonth:1 + _mounthPicker.selectedIndex];
        [comps setYear:_minYear + _yearPicker.selectedIndex];
         NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        if (self.customDatePickerChangeCallback)
        {
            self.customDatePickerChangeCallback(date);
        }
        
        [self.delegate datePickerDateChange:self forDate:date];
    }
}

@end
