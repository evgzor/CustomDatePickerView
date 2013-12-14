//
//  UICustomDatePicker.m
//  Seldon_2
//
//  Created by admin on 12.08.13.
//  Copyright (c) 2013 AETP. All rights reserved.
//

#import "CustomDatePicker.h"
#import "CustomPickerView.h"

#define MIN_YEAR_VALUE 1900 

@interface  CustomDatePicker() <CustomPickerControllerDelegate>
{
    CustomPickerView* _dayPicker;
    CustomPickerView* _yearPicker;
    CustomPickerView* _mounthPicker;
    
    NSInteger _year;
    
    NSInteger _minYear;
    
    UIImage* _dayImage;
    UIImage* _monthImage;
    UIImage* _yearImage;
}

@property(strong,retain)UIImage* dayImage;
@property(strong,retain)UIImage* monthImage;
@property(strong,retain)UIImage* yearImage;

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

-(void) defaultDataInit
{
    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 250, 50);
    self.dayImage = [UIImage imageNamed:@"day"];
    self.monthImage = [UIImage imageNamed:@"month"];
    self.yearImage = [UIImage imageNamed:@"year"];
    
    _dayPicker = nil;
    _yearPicker = nil;
    _mounthPicker = nil;
    
    _year = MIN_YEAR_VALUE;
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    self.date = [NSDate date];
    _minYear = MIN_YEAR_VALUE;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:MIN_YEAR_VALUE];
    
    self.minimumDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    self.maximumDate = [NSDate date];

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
        self.dayImage = dayImage;
        self.monthImage = monthImage;
        self.yearImage = yearImage;
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


#pragma mark prepare View
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _dayImage.size.width + _monthImage.size.width + _yearImage.size.width - 2*TABLE_RECT_OFFSET, _dayImage.size.height);
    
    if (_maximumDate < _date)
    {
        _date = _maximumDate;
    }
    
    NSDateComponents *components = [_calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:_maximumDate];
    
    NSInteger year = [components year];
    
    NSMutableArray* years = [NSMutableArray array];

    _minYear = [[_calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:_minimumDate] year];
    
    /*[years enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        [years addObject:[NSString stringWithFormat:@"%d",idx]];
        *stop = idx>_minYear;
    }];*/
    for (int i = _minYear; i<=year; i++)
    {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _yearPicker= [[CustomPickerView alloc] initWithFrame:CGRectMake(_dayImage.size.width + _monthImage.size.width-2*TABLE_RECT_OFFSET, 0, _yearImage.size.width, _yearImage.size.height) background:_yearImage itemVerticalOffset:0.0f andData:years];
    _yearPicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    //[_yearPicker setDataIndex:_date.y];
    _yearPicker.delegate = self;
    
    NSDateFormatter *df = [NSDateFormatter new];
    // change locale if the standard is not what you want
    
    NSArray *monthNames = [df standaloneMonthSymbols];
    _mounthPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(_dayImage.size.width - TABLE_RECT_OFFSET , 0, _monthImage.size.width, _monthImage.size.height)background:_monthImage itemVerticalOffset:0.0f andData:monthNames];
    _mounthPicker.delegate = self;
    _mounthPicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init];

    
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
                              inUnit:NSMonthCalendarUnit
                             forDate:[cal dateFromComponents:comps]];
    NSLog(@"%d", range.length);
    
    NSMutableArray* days = [NSMutableArray array];
    
    for (int i= 1; i<range.length; i++)
    {
        [days addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _dayPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 0, _dayImage.size.width, _dayImage.size.height) background:_dayImage itemVerticalOffset:0.0f andData:days];
    _dayPicker.delegate = self;
    
    _dayPicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [_dayPicker retrieveCustomPickerViewControllerDidSpinCallback:^(int day)
    {
        NSLog(@"Day %d",day);
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
    
    [_yearPicker retrieveCustomPickerViewControllerDidSpinCallback:^(int year)
    {
        _year = _minYear - 1 + year;
        NSLog(@"Year %d",_year);
    }];
    
    [_mounthPicker retrieveCustomPickerViewControllerDidSpinCallback:^(int month)
    {
        NSCalendar* cal = [NSCalendar currentCalendar];
        
         NSDateComponents* comps = [[NSDateComponents alloc] init];
        [comps setMonth:month];
        [components setYear:_year];
        
        NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:[cal dateFromComponents:comps]];
        
        NSMutableArray* days = [NSMutableArray array];
        
        for (int i= 1; i<=range.length; i++)
        {
            [days addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _dayPicker.data4Rows = days;
        
        NSLog(@"Month %d",month);
        
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)dealloc
{
    _dayPicker = nil;
    _yearPicker = nil;
    _yearPicker = nil;
    _monthImage = nil;
    _monthImage = nil;
    self.dayImage = nil;
    self.yearImage = nil;
    self.monthImage = nil;
    self.calendar = nil;
}

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
    NSLog(@"index %d",dial.selectedIndex);
    if (_customDatePickerChangeCallback)
    {
        NSDate *date = [[NSDate alloc] init];
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:1+_dayPicker.selectedIndex];
        [comps setMonth:1 + _mounthPicker.selectedIndex];
        [comps setYear:_minYear + _yearPicker.selectedIndex];
        date = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        if (self.customDatePickerChangeCallback)
        {
            self.customDatePickerChangeCallback(date);
        }
        
        [self.delegate datePickerDateChange:self forDate:date];
    }
}

@end
