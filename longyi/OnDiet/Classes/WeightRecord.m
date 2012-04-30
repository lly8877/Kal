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
@synthesize noteString = m_noteString;
@synthesize estimateWeight = m_estimateWeight;

+ (WeightRecord*)weightRecordWithDate:(NSDate*)in_date noteString:(NSString*)in_note andWeightInKg:(CGFloat)in_weightInKg
{
    return [[[WeightRecord alloc] initWithDate:in_date noteString:(NSString*)in_note andWeightInKg:in_weightInKg] autorelease];
}

+ (WeightRecord*)estimateWeightRecordWithDate:(NSDate*)in_date andWeightInKg:(CGFloat)in_weightInKg
{
    WeightRecord* estimateWeightRecord = [[[WeightRecord alloc] initWithDate:in_date noteString:(NSString*)@"" andWeightInKg:in_weightInKg] autorelease];
    estimateWeightRecord.estimateWeight = YES;
    return estimateWeightRecord;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"WeightRecord date:%@, weight:%f, noteString:%@, IsEstimate:%i", self.date, self.weightInKg, self.noteString, self.estimateWeight];
}

- (id)initWithDate:(NSDate*)in_date noteString:(NSString*)in_note andWeightInKg:(CGFloat)in_weightInKg
{
    if ((self = [super init])) {
        self.date = in_date;
        self.weightInKg = in_weightInKg;
        self.noteString = in_note;
        self.estimateWeight = NO;
    }
    return self;
}

- (void)dealloc
{
    [m_date release];
    [super dealloc];
}
@end
