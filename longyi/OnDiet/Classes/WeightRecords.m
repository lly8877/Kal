//
//  WeightRecords.m
//  OnDiet
//
//  Created by Longyi Li on 4/22/12.
//
#import <sqlite3.h>
#import "WeightRecords.h"

@implementation WeightRecords

+ (NSMutableArray*) weightRecordFromDate:(NSDate*)in_fromDate ToDate:(NSDate*)in_toDate;
{
    NSLog(@"Fetching weight records from the database between %@ and %@...", in_fromDate, in_toDate);
	NSMutableArray* weightsRecords = [NSMutableArray array];
    
    sqlite3* db;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"weightRecords.sqlite"];
    
    NSDateFormatter* l_dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
	if(sqlite3_open([writableDBPath UTF8String], &db) == SQLITE_OK) 
    {
		const char* l_sqlQuery = "select weight, dateOfWeight from weightRecords where dateOfWeight between ? and ?";
		sqlite3_stmt* l_statement;
		if(sqlite3_prepare_v2(db, l_sqlQuery, -1, &l_statement, NULL) == SQLITE_OK) 
        {
            [l_dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            sqlite3_bind_text(l_statement, 1, [[l_dateFormatter stringFromDate:in_fromDate] UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(l_statement, 2, [[l_dateFormatter stringFromDate:in_toDate] UTF8String], -1, SQLITE_STATIC);
            
			while(sqlite3_step(l_statement) == SQLITE_ROW) 
            {
				CGFloat l_weight = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 0)] floatValue];
				NSDate* l_date = [l_dateFormatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 1)]];
                [weightsRecords addObject:[WeightRecord weightRecordWithDate:l_date andWeightInKg:l_weight]];
			}
		}
		sqlite3_finalize(l_statement);
	}
	sqlite3_close(db);
    return weightsRecords;
}
@end
