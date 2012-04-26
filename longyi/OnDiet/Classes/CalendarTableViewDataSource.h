//
//  CalendarTableViewDataSource.h
//  OnDiet
//
//  Created by Longyi Li on 4/22/12.
//

#import <Foundation/Foundation.h>

#import "Kal.h"

@class WeightRecord;

/*
 *    HolidaySqliteDataSource
 *    ---------------------
 *
 *  This example data source retrieves world holidays
 *  from an Sqlite database stored locally in the application bundle.
 *  When the presentingDatesFrom:to:delegate message is received,
 *  it queries the database for the specified date range and
 *  instantiates a Holiday object for each row in the result set.
 *
 */
@interface CalendarTableViewDataSource : NSObject <KalDataSource>
{
@private
    NSMutableArray* m_items;
    NSMutableArray* m_weightRecords;
}

+ (CalendarTableViewDataSource*) dataSource;
- (NSArray*) colorDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end
