//
//  WeightRecord.m
//  OnDiet
//
//  Created by Longyi Li on 4/22/12.
//

#import "WeightRecord.h"

@implementation WeightRecord
@synthesize date = m_date;
@synthesize weightInKg = m_weightInKg;

+ (WeightRecord*)weightRecordWithDate:(NSDate*)in_date andWeightInKg:(CGFloat)in_weightInKg
{
    return [[[WeightRecord alloc] initWithDate:in_date andWeightInKg:in_weightInKg] autorelease];
}

- (id)initWithDate:(NSDate*)in_date andWeightInKg:(CGFloat)in_weightInKg
{
    if ((self = [super init])) {
        self.date = in_date;
        self.weightInKg = in_weightInKg;
    }
    return self;
}

- (void)dealloc
{
    [m_date release];
    [super dealloc];
}
@end
