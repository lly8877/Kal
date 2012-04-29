//
//  EditWeightViewController.m
//  OnDiet
//
//  Created by Longyi Li on 4/27/12.
//

#import "EditWeightViewController.h"
#import "WeightRecords.h"

#define MAXWEIGHTINT 300

@interface EditWeightViewController(privateMethods)
- (void) onCancelButtonTapped;
- (void) onApplyButtonTapped;
@end

@implementation EditWeightViewController

@synthesize initDate = m_initDate;
@synthesize toolbar = m_toolbar;
@synthesize weightNotesTextView = m_weightNotesTextView;
@synthesize weightPickerView = m_weightPickerView;
@synthesize delegate = m_delegate;

#pragma mark view life cycle
#pragma mark -

- (void)loadView
{
    [super loadView];
    self.toolbar = [[[UIToolbar alloc] initWithFrame:CGRectZero] autorelease];
    // toolbar
	NSMutableArray *l_toolbarItems = [NSMutableArray arrayWithCapacity:4];
    {
        // apply
        UIBarButtonItem* l_cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                        target:nil 
                                                                                        action:@selector(onCancelButtonTapped)];
        
        // Bar buttons for the view.
        UIBarButtonItem* l_spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                                     target:nil 
                                                                                     action:nil];
        
        UIBarButtonItem* l_applyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                       target:nil 
                                                                                       action:@selector(onApplyButtonTapped)];
        
        // add all the items to array for toolbar.
        [l_toolbarItems addObject:l_cancelButton];
        [l_toolbarItems addObject:l_spaceItem];
        [l_toolbarItems addObject:l_applyButton];
    }
    self.toolbar.items = l_toolbarItems;
    
    self.weightNotesTextView = [[[UITextView alloc] initWithFrame:CGRectZero] autorelease];
    self.weightPickerView = [[[UIPickerView alloc] initWithFrame:CGRectZero] autorelease];
    self.weightPickerView.delegate = self;
    self.weightPickerView.dataSource = self;
    [self.view addSubview:self.toolbar];
    //[self.view addSubview:self.weightTodayLabel];
    [self.view addSubview:self.weightPickerView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect l_bounds = [[UIScreen mainScreen] applicationFrame];
    self.toolbar.frame = CGRectMake(0, 0, l_bounds.size.width, 45);
    int l_pickerViewHeight = 162;
    self.weightPickerView.frame = CGRectMake(0, 45, l_bounds.size.width, l_pickerViewHeight);
    int l_margin = 10;
    self.weightNotesTextView.frame = CGRectMake(
                                                l_margin, 
                                                l_pickerViewHeight+l_margin, 
                                                l_bounds.size.width, 
                                                l_bounds.size.height - l_pickerViewHeight - l_margin * 2
                                                );
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (initWeight > MAXWEIGHTINT || initWeight < 0)
    {
        return;
    }
    int intPart = (int)initWeight;
    int floatPart = (int)((initWeight*10 - intPart*10));
    [self.weightPickerView selectRow:intPart inComponent:0 animated:YES];
    [self.weightPickerView selectRow:floatPart inComponent:1 animated:YES];
}

#pragma mark init and dealloc
#pragma mark -

- (id)initWithWeight:(CGFloat)weight
{
    [super init];
    initWeight = weight;
    return self;
}

- (id)initWithDate:(NSDate*)in_Date
{
    [super init];
    self.initDate = in_Date;
    initWeight = [WeightRecords weightRecordForDate:in_Date];
    return self;
}


- (void)dealloc
{
    [m_toolbar release];
    [m_weightNotesTextView release];
    [m_weightPickerView release];
    [m_initDate release];
    [super dealloc];
}

#pragma mark UIPickerViewDataSource
#pragma mark -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return MAXWEIGHTINT;
    }
    else
    {
        return 10;
    }
}

#pragma mark UIPickerViewDelegate
#pragma mark -

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 70;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return component == 0 ? 100 : 70;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    int width = component == 0 ? 100 : 70;
    width -= 20;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 70)];
    NSString* number = [[NSNumber numberWithInt:row] stringValue];
    if (component == 1)
    {
        number = [@"." stringByAppendingString:number];
    }
    label.text = number;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:40];
    
    if (component == 0)
        label.textAlignment = UITextAlignmentRight;
    
    return label;

}

@end

@implementation EditWeightViewController(privateMethods)

- (void) onCancelButtonTapped
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) onApplyButtonTapped
{
    int intPart = [self.weightPickerView selectedRowInComponent:0];
    int floatPart = [self.weightPickerView selectedRowInComponent:1];
    [WeightRecords saveWeight:intPart+floatPart*0.1 ForDate:self.initDate];
    [self.delegate dataSaved];
    [self dismissModalViewControllerAnimated:YES];
}
@end