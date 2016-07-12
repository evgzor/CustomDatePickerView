
#import "CustomPickerView.h"

#define ROW_HEIGHT 34


@interface CustomPickerView(PrivateMethods)
- (void)snap;
- (UIImage *)addText:(UIImage *)img text:(NSString *)text;
- (UIImage *)imageWithColor:(UIColor *)color forRect:(CGRect) rect;

@end

@implementation CustomPickerView

@synthesize tableView, strings, delegate;
@synthesize isSpinning = _isSpinning;
@synthesize selectedString = _selectedString;
@synthesize selectedIndex = _selectedIndex;
@synthesize verticalLabelOffset = _verticalLabelOffset;
@synthesize labelFontSize = _labelFontSize;
@synthesize data4Rows = _data4Rows;


#pragma mark - init functions

- (id)initWithFrame:(CGRect)frame
         background:(UIImage*)backImage
itemVerticalOffset:(CGFloat)offset andData:(NSArray*) data
{
    CGRect rect;
    rect.origin.x = frame.origin.x;
    rect.origin.y = frame.origin.y;
    rect.size.width = backImage.size.width;
    rect.size.height = backImage.size.height;
    self.data4Rows = data;
    
    self = [super initWithFrame:rect];
    
    if (self)
    {
        self.verticalLabelOffset = offset;
        self.isSpinning = NO;
        isAnimating = NO;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(TABLE_RECT_OFFSET/2, TABLE_RECT_OFFSET/2, rect.size.width-TABLE_RECT_OFFSET, rect.size.height-TABLE_RECT_OFFSET) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = ROW_HEIGHT;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *overlayView = [[UIImageView alloc] initWithImage:backImage];
        overlayView.center = CGPointMake(rect.size.width/2, rect.size.height/2);
        
        self.tableView.backgroundView = overlayView;// this depends how u would like add background vie
        [self addSubview:self.tableView]; //on base image
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [self snap];
    }
    return self;
}

#pragma mark - memory managment

- (void)dealloc
{
    self.customPickerViewControllerDidSpinCallback = nil;
    self.tableView = nil;
    self.data4Rows = nil;
    self.strings = nil;
}


#pragma mark - UITableViev delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = nil;
    if (section == 0)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerView = nil;
    if (section == 0)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 19)];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 20;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 19;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data4Rows.count;
}

#pragma mark - UITableVievDataSourse

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellName = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell *cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        NSString* dataObjectStr = [NSString stringWithFormat:@"%@",[self.data4Rows objectAtIndex:indexPath.row] ];
        
        UIImage* image = [self addText:[self imageWithColor:[UIColor clearColor]forRect:CGRectMake(0, 0, 100, 30)] text: dataObjectStr];
        UIImageView* numberImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 80, ROW_HEIGHT)];
        numberImage.contentMode = UIViewContentModeCenter;
        numberImage.image = image;
        [cell.contentView addSubview:numberImage];

    }
    
    return cell;
}



#pragma mark UIScrollViewDelegate methods

-(void)retrieveCustomPickerViewControllerDidSpinCallback:(CustomPickerViewControllerDidSpinCallback)callback
{
    self.customPickerViewControllerDidSpinCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.isSpinning = YES;
    [self.delegate pickerControllerDidSpin:self];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        self.isSpinning = NO;
        isAnimating = NO;
        [self snap];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isSpinning = NO;
    isAnimating = NO;
    [self snap];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (isAnimating)
    {
        isAnimating = NO;
        self.isSpinning = NO;
        [self.delegate pickerController:self didSnapToString:self.selectedString];
        if (self.customPickerViewControllerDidSpinCallback)
        {
            self.customPickerViewControllerDidSpinCallback((NSInteger)(self.selectedIndex + 1));
        }

    }
    else
        [self snap];
}

#pragma mark - private methods

- (void)setDataIndex:(NSUInteger)index
{
    NSInteger rowsCount = (NSInteger)[self.tableView numberOfRowsInSection:0];
    _selectedIndex = index < rowsCount ? index : rowsCount;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

-(void)setData4Rows:(NSArray *)data4Rows
{
    _data4Rows = data4Rows;
    [self.tableView reloadData];
    [self snap];
}

- (void)snap
{
    if (isAnimating)
        return;
    
    isAnimating = YES;
    
    self.isSpinning = NO;
    
    double verticalPadding = (self.tableView.frame.size.height - self.tableView.rowHeight) * .5;
    
    for (int i=0; i<[[self.tableView visibleCells] count]; i++)
    {
        UITableViewCell *cell = [[self.tableView visibleCells] objectAtIndex:i];
        
        BOOL selected = CGRectContainsPoint(CGRectMake(0, self.tableView.contentOffset.y + verticalPadding,
                                                       self.tableView.frame.size.width, self.tableView.rowHeight),cell.center);
        if (selected)
        {
            isAnimating = YES;
            self.isSpinning = NO;
            
            [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            _selectedIndex = [self.tableView indexPathForCell:cell].row;
            if ([self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:cell]].origin.y == self.tableView.contentOffset.y + (self.tableView.frame.size.height - ROW_HEIGHT) * .5)
            {
                _selectedIndex = [self.tableView indexPathForCell:cell].row;
                [self.delegate pickerController:self didSnapToString:self.selectedString];
                isAnimating = NO;
            }
        }
    }
}


-(UIImage *)addText:(UIImage *)img text:(NSString *)text
{
    
    CGPoint point = CGPointMake(10.0f, 3.0f);
    
    UIFont *font = [UIFont boldSystemFontOfSize:18];
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0,0,img.size.width,img.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, img.size.width, img.size.height);
    [[UIColor whiteColor] set];
    
    if ([text respondsToSelector:@selector(drawInRect:withAttributes:)]) {
        NSDictionary *attributes = @{ NSFontAttributeName: font,
                                      NSForegroundColorAttributeName: [UIColor whiteColor]};
        [text drawInRect:CGRectIntegral(rect) withAttributes:attributes];
    }
    else
    {
        
        /// Make a copy of the default paragraph style
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        /// Set line break mode
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        /// Set text alignment
        paragraphStyle.alignment = NSTextAlignmentRight;
        
        NSDictionary *attributes = @{ NSFontAttributeName: font,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0)
        {
            [text drawInRect:CGRectIntegral(rect) withFont:font];
        }
        else
        {
            [text drawInRect:rect withAttributes:attributes];
        }
        
        
       
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

- (UIImage *)imageWithColor:(UIColor *)color forRect:(CGRect) rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
