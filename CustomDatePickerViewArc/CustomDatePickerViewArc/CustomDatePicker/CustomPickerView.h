
//#import "BKGlobals.h"

static const NSInteger kTableRectOfset =  6;

typedef void (^CustomPickerViewControllerDidSpinCallback)(NSInteger);

@protocol CustomPickerControllerDelegate;

@interface CustomPickerView : UIView <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,assign) id<CustomPickerControllerDelegate> delegate;
@property (nonatomic,copy) CustomPickerViewControllerDidSpinCallback customPickerViewControllerDidSpinCallback;
@property(nonatomic, readonly) NSInteger selectedIndex;
@property(nonatomic,readonly) BOOL isSpinning;

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
