//
//  WeightRecord.h
//  OnDiet
//
//  Created by Longyi Li on 4/22/12.
//

#import <Foundation/Foundation.h>

@interface WeightRecord : NSObject
{
    NSDate* m_date;
    CGFloat m_weightInKg;
    NSString* m_noteString;
}

@property (nonatomic, retain) NSDate* date;
@property (nonatomic, assign) CGFloat weightInKg;
@property (nonatomic, retain) NSString* noteString;

+ (WeightRecord*)weightRecordWithDate:(NSDate*)in_date noteString:(NSString*)in_note andWeightInKg:(CGFloat)in_weightInKg;
@end
