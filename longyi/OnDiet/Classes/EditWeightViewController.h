//
//  EditWeightViewController.h
//  OnDiet
//
//  Created by Longyi Li on 4/27/12.
//

#import <UIKit/UIKit.h>
#import "EditWeightViewControllerDelegate.h"
#import "WeightRecord.h"

@interface EditWeightViewController : UIViewController
<
UIPickerViewDelegate,
UIPickerViewDataSource,
UITextViewDelegate
>
{

@private
    UIToolbar* m_toolbar;
    UITextView* m_weightNotesTextView;
    UIPickerView* m_weightPickerView;
    WeightRecord* m_initRecord;
    
    id<EditWeightViewControllerDelegate> m_delegate;
}

@property (nonatomic, retain) WeightRecord* initRecord;
@property (nonatomic, retain) UIToolbar* toolbar;
@property (nonatomic, retain) UITextView* weightNotesTextView;
@property (nonatomic, retain) UIPickerView* weightPickerView;
@property (nonatomic, assign) id<EditWeightViewControllerDelegate> delegate;

- (id)initWithDate:(NSDate*)in_Date;

@end
