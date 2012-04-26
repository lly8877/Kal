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
}

@property (nonatomic, retain) NSDate* date;
@property (nonatomic, assign) CGFloat weightInKg;

+ (WeightRecord*)weightRecordWithDate:(NSDate*)in_date andWeightInKg:(CGFloat)in_weightInKg;
@end
