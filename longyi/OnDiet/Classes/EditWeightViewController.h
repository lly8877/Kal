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
    
    UIView* m_leftBackground;
    UIView* m_rightBackground;
    UIView* m_topBackground;
    UIView* m_bottomBackground;
    
    
    id<EditWeightViewControllerDelegate> m_delegate;
}

@property (nonatomic, retain) NSDate* initDate;
@property (nonatomic, retain) UIToolbar* toolbar;
@property (nonatomic, retain) UITextView* weightNotesTextView;
@property (nonatomic, retain) UIPickerView* weightPickerView;
@property (nonatomic, assign) id<EditWeightViewControllerDelegate> delegate;

@property (nonatomic, retain) UIView* leftBackground;
@property (nonatomic, retain) UIView* rightBackground;
@property (nonatomic, retain) UIView* topBackground;
@property (nonatomic, retain) UIView* bottomBackground;

- (id)initWithDate:(NSDate*)in_Date;

@end
