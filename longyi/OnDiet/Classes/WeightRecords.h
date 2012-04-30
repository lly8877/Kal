//
//  WeightRecords.h
//  OnDiet
//
//  Created by Longyi Li on 4/22/12.
//

#import <Foundation/Foundation.h>
#import "WeightRecord.h"

@interface WeightRecords : NSObject

+ (NSMutableArray*) weightRecordFromDate:(NSDate*)in_fromDate ToDate:(NSDate*)in_toDate;
+ (WeightRecord*) weightRecordForDate:(NSDate*)in_date;
+ (WeightRecord*) lastWeightRecordBeforeDate:(NSDate *)in_date;
+ (WeightRecord*) firstWeightRecordAfterDate:(NSDate *)in_date;
+ (NSMutableArray*) arrayFillEstimateWeightTo:(NSMutableArray*)weightRecords FromDate:(NSDate *)in_fromDate ToDate:(NSDate *)in_toDate;
+ (BOOL) saveWeight:(CGFloat)in_weight noteString:(NSString*)in_note ForDate:(NSDate*)in_date;
+ (NSArray*) findWeightRecordBeforeAndAfterWithDate:(NSDate*)in_date inRecords:(NSMutableArray*)weightRecords;
+ (float) firstDayWeight;
+ (NSMutableArray*) absColorArrayForWeightRecords:(NSMutableArray*)array;
@end
