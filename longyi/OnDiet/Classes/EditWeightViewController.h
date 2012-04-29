//
//  EditWeightViewController.h
//  OnDiet
//
//  Created by Longyi Li on 4/27/12.
//

#import <UIKit/UIKit.h>
@class KalViewController;
@protocol EditWeightViewControllerDelegate <NSObject>

- (void) dataSaved;

@end

@interface EditWeightViewController : UIViewController
<UIPickerViewDelegate,UIPickerViewDataSource>
{

@private
    UIToolbar* m_toolbar;
    UITextView* m_weightNotesTextView;
    UIPickerView* m_weightPickerView;
    CGFloat initWeight;
    NSDate* m_initDate;
    id<EditWeightViewControllerDelegate> m_delegate;
}

@property (nonatomic, retain) NSDate* initDate;
@property (nonatomic, retain) UIToolbar* toolbar;
@property (nonatomic, retain) UITextView* weightNotesTextView;
@property (nonatomic, retain) UIPickerView* weightPickerView;
@property (nonatomic, assign) id<EditWeightViewControllerDelegate> delegate;
- (id)initWithDate:(NSDate*)in_Date;

@end
