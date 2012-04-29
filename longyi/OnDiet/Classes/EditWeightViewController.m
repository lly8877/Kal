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

@synthesize initRecord = m_initRecord;
@synthesize toolbar = m_toolbar;
@synthesize weightNotesTextView = m_weightNotesTextView;
@synthesize weightPickerView = m_weightPickerView;
@synthesize delegate = m_delegate;

@synthesize leftBackground = m_leftBackground;
@synthesize rightBackground = m_rightBackground;
@synthesize topBackground = m_topBackground;
@synthesize bottomBackground = m_bottomBackground;

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
    
    // four view to cover the picker
    self.topBackground = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    self.bottomBackground = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    self.leftBackground = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    self.rightBackground = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    
    self.weightNotesTextView = [[[UITextView alloc] initWithFrame:CGRectZero] autorelease];
    self.weightPickerView = [[[UIPickerView alloc] initWithFrame:CGRectZero] autorelease];
    self.weightPickerView.delegate = self;
    self.weightPickerView.dataSource = self;
    
    
    
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.weightPickerView];
    [self.view addSubview:self.weightNotesTextView];
#if 0
    [self.view addSubview:self.leftBackground];
    [self.view addSubview:self.rightBackground];
    [self.view addSubview:self.topBackground];
    [self.view addSubview:self.bottomBackground];
#endif
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // constants
    int l_pickerViewHeight = 162;
    int l_pickerViewWidth = 200;
    int l_margin = 0;
    int l_toolbarHeight = 45;
    int leftRightMargin = 17;
    int topbottomMargin = 11;
    int textViewHeight = 160;
    
    CGRect l_bounds = [[UIScreen mainScreen] applicationFrame];
    
    // toolbar
    self.toolbar.frame = CGRectMake(0, 0, l_bounds.size.width, l_toolbarHeight);
    
    // picker
    self.weightPickerView.frame = CGRectMake(
                                             0,
                                             l_toolbarHeight + textViewHeight,
                                             l_pickerViewWidth,
                                             l_pickerViewHeight
                                             );
    self.weightPickerView.backgroundColor = COLOR_LIGHT_BLUE;
    self.weightPickerView.showsSelectionIndicator = NO;
    self.weightPickerView.clipsToBounds = YES;
    
#if 0
    self.leftBackground.frame = CGRectMake(
                                           self.weightPickerView.frame.origin.x, 
                                           self.weightPickerView.frame.origin.y, 
                                           leftRightMargin,
                                           l_pickerViewHeight
                                           );
    self.rightBackground.frame = CGRectMake(
                                            self.weightPickerView.frame.origin.x + l_pickerViewWidth - leftRightMargin, 
                                            self.weightPickerView.frame.origin.y, 
                                            leftRightMargin,
                                            l_pickerViewHeight
                                            );
    self.topBackground.frame = CGRectMake(
                                          self.weightPickerView.frame.origin.x, 
                                          self.weightPickerView.frame.origin.y, 
                                          l_pickerViewWidth,
                                          topbottomMargin
                                          );
    self.bottomBackground.frame = CGRectMake(
                                             self.weightPickerView.frame.origin.x,
                                             self.weightPickerView.frame.origin.y + l_pickerViewHeight - topbottomMargin, 
                                             l_pickerViewWidth,
                                             topbottomMargin
                                             );
    self.weightPickerView.backgroundColor = COLOR_LIGHT_BLUE;
    self.leftBackground.backgroundColor = COLOR_LIGHT_BLUE;
    self.rightBackground.backgroundColor = COLOR_LIGHT_BLUE;
    self.topBackground.backgroundColor = COLOR_LIGHT_BLUE;
    self.bottomBackground.backgroundColor = COLOR_LIGHT_BLUE;
#endif
    
    // textview
    self.weightNotesTextView.frame = CGRectMake(
                                                l_margin, 
                                                l_margin + l_toolbarHeight, 
                                                l_bounds.size.width - l_margin*2, 
                                                textViewHeight - l_margin * 2
                                                );
    self.weightNotesTextView.font = [UIFont systemFontOfSize:20];
    self.weightNotesTextView.delegate = self;
    self.weightNotesTextView.returnKeyType = UIReturnKeyDone;
    self.weightNotesTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    if (self.initRecord.noteString)
    {
        self.weightNotesTextView.text = self.initRecord.noteString;
    }
    // background view
    self.view.backgroundColor = COLOR_LIGHT_BLUE;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.initRecord.weightInKg > MAXWEIGHTINT || self.initRecord.weightInKg < 0)
    {
        return;
    }
    int intPart = (int)self.initRecord.weightInKg;
    int floatPart = (int)((self.initRecord.weightInKg*10 - intPart*10));
    [self.weightPickerView selectRow:intPart inComponent:0 animated:YES];
    [self.weightPickerView selectRow:floatPart inComponent:1 animated:YES];
}

#pragma mark init and dealloc
#pragma mark -

- (id)initWithDate:(NSDate*)in_Date
{
    [super init];
    self.initRecord = [WeightRecords weightRecordForDate:in_Date];
    if (!self.initRecord)
    {
        self.initRecord = [WeightRecord weightRecordWithDate:in_Date noteString:nil andWeightInKg:0];
    }
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

#pragma mark -
#pragma mark UITextViewDelegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)in_range replacementText:(NSString *)in_text
{
    if (in_text.length > 1)
    {
        // reach here because it should be a "paste" change here.
        // we replace all '\n' to ' ' and lets change the text ourself.
        NSString* l_stringToReplace = [in_text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        self.weightNotesTextView.text = [self.weightNotesTextView.text stringByReplacingCharactersInRange:in_range withString:l_stringToReplace];
        // already replaced the string, return NO.
        return NO;
    }
    else if([@"\n" isEqual:in_text]) 
    {
        [self.weightNotesTextView resignFirstResponder];
        return NO;
    }
    return YES;
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
    [WeightRecords saveWeight:intPart+floatPart*0.1 noteString:self.weightNotesTextView.text ForDate:self.initRecord.date];
    [self.delegate dataSaved];
    [self dismissModalViewControllerAnimated:YES];
}
@end