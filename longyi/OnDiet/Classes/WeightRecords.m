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
    NSLog(@"%s Fetching weight records from the database between %@ and %@...", __PRETTY_FUNCTION__, in_fromDate, in_toDate);
	NSMutableArray* weightsRecords = [NSMutableArray array];
    
    sqlite3* db;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"weightRecords.sqlite"];
    
    NSDateFormatter* l_dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
	if(sqlite3_open([writableDBPath UTF8String], &db) == SQLITE_OK) 
    {
		const char* l_sqlQuery = "select weight, dateOfWeight, note from weightRecords where dateOfWeight between ? and ?";
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
                NSString* l_note = [NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 2)];
                [weightsRecords addObject:[WeightRecord weightRecordWithDate:l_date noteString:l_note andWeightInKg:l_weight]];
			}
		}
		sqlite3_finalize(l_statement);
	}
	sqlite3_close(db);
    return weightsRecords;
}

+ (BOOL) saveWeight:(CGFloat)in_weight noteString:(NSString*)in_note ForDate:(NSDate *)in_date
{
    BOOL result = false;
    NSLog(@"%s saving weight %f note %@ for Date %@ to Database", __PRETTY_FUNCTION__, in_weight, in_note, in_date);
    

    NSString* l_weightNumberString = [[NSNumber numberWithFloat:((int)(in_weight * 10))/10.0] stringValue];
    
    sqlite3* db;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"weightRecords.sqlite"];
    
    NSDateFormatter* l_dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
	if(sqlite3_open([writableDBPath UTF8String], &db) == SQLITE_OK) 
    {

        sqlite3_stmt* l_statement;
        const char* l_sqlQuery = "delete from weightRecords where dateOfWeight = ?;";
        if(sqlite3_prepare_v2(db, l_sqlQuery, -1, &l_statement, NULL) == SQLITE_OK) 
        {
            [l_dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            sqlite3_bind_text(l_statement, 1, [[l_dateFormatter stringFromDate:in_date] UTF8String], -1, SQLITE_STATIC);
            
			if(sqlite3_step(l_statement) != SQLITE_DONE) 
            {
                sqlite3_finalize(l_statement);
                sqlite3_close(db);
                return false;
			}
		}
        
        sqlite3_reset(l_statement);
        l_sqlQuery = "insert or replace into weightRecords (dateOfWeight, weight, note) values (?, ?, ?)";

		if(sqlite3_prepare_v2(db, l_sqlQuery, -1, &l_statement, NULL) == SQLITE_OK) 
        {
            [l_dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            sqlite3_bind_text(l_statement, 1, [[l_dateFormatter stringFromDate:in_date] UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(l_statement, 2, [l_weightNumberString UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(l_statement, 3, [in_note UTF8String], -1, SQLITE_STATIC);
            
			if(sqlite3_step(l_statement) == SQLITE_DONE) 
            {
                result = true;
			}
		}
        
		sqlite3_finalize(l_statement);
	}
	sqlite3_close(db);
    return result;
}

+ (WeightRecord*) weightRecordForDate:(NSDate *)in_date
{
    NSArray* array = [[self class] weightRecordFromDate:(NSDate*)in_date ToDate:[in_date dateByAddingTimeInterval: 3600*24]]; 
    if(array.count == 0)
        return nil;
    return (WeightRecord*)[array objectAtIndex:0];

}
@end
