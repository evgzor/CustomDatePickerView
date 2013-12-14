
//#import "BKGlobals.h"

#define TABLE_RECT_OFFSET 6

typedef void (^CustomPickerViewControllerDidSpinCallback)(int);

@protocol CustomPickerControllerDelegate;

@interface CustomPickerView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    BOOL isSpinning;
    BOOL isAnimating;
    NSArray* _data4Rows;
    
    CustomPickerViewControllerDidSpinCallback _customPickerViewControllerDidSpinCallback;
}

@property (nonatomic,copy) CustomPickerViewControllerDidSpinCallback customPickerViewControllerDidSpinCallback;

-(void)retrieveCustomPickerViewControllerDidSpinCallback:(CustomPickerViewControllerDidSpinCallback)callback;

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *strings;
@property(nonatomic,assign) id<CustomPickerControllerDelegate> delegate;
@property(nonatomic,assign) BOOL isSpinning;
@property(nonatomic,readonly) NSString *selectedString;
@property(nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,assign) NSInteger verticalLabelOffset;
@property(nonatomic,assign) NSInteger labelFontSize;
@property(nonatomic,retain) NSArray* data4Rows;
@property(nonatomic,retain) UIImageView* backgroundImgView;

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
