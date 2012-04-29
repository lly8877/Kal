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
+ (BOOL) saveWeight:(CGFloat)in_weight noteString:(NSString*)in_note ForDate:(NSDate*)in_date;

@end
