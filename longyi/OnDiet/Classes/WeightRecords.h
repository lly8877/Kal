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
+ (CGFloat) weightRecordForDate:(NSDate*)in_date;
+ (BOOL) saveWeight:(CGFloat)in_weight ForDate:(NSDate*)in_date;

@end
