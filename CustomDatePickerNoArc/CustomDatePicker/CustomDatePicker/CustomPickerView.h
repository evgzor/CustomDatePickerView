
//#import "BKGlobals.h"

#define TABLE_RECT_OFFSET 6

typedef void (^CustomPickerViewControllerDidSpinCallback)(NSInteger);

@protocol CustomPickerControllerDelegate;

@interface CustomPickerView : UIView <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,assign) id<CustomPickerControllerDelegate> delegate;
@property(nonatomic,assign, readonly) BOOL isSpinning;
@property(nonatomic, readonly) BOOL isAnimating;
@property(nonatomic, readonly) NSString *selectedString;
@property(nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic,copy) CustomPickerViewControllerDidSpinCallback customPickerViewControllerDidSpinCallback;
@property(nonatomic, retain) NSMutableArray *strings;
@property(nonatomic, assign) NSInteger verticalLabelOffset;
@property(nonatomic, assign) NSInteger labelFontSize;

-(void)retrieveCustomPickerViewControllerDidSpinCallback:(CustomPickerViewControllerDidSpinCallback)callback;



-(void)setData4Rows:(NSArray *)data4Rows;

- (id)initWithFrame:(CGRect)frame
         background:(UIImage*)backImage
 itemVerticalOffset:(CGFloat)offset andData:(NSArray*) data;

- (void)setDataIndex:(NSUInteger)index;

@end

@protocol CustomPickerControllerDelegate <NSObject>
- (void)pickerControllerDidSpin:(CustomPickerView *)controller;
@required
- (void)pickerController:(CustomPickerView *)dial didSnapToString:(NSString *)string;
@end
