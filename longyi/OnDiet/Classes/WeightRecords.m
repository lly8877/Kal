//
//  WeightRecords.m
//  OnDiet
//
//  Created by Longyi Li on 4/22/12.
//
#import <sqlite3.h>
#import "WeightRecords.h"
#import "KalDate.h"

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
		const char* l_sqlQuery = "select weight, dateOfWeight, note from weightRecords where dateOfWeight between ? and ? order by dateOfWeight asc";
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

+ (WeightRecord*) lastWeightRecordBeforeDate:(NSDate *)in_date
{
    NSLog(@"%s Fetching last weight record from the database before %@...", __PRETTY_FUNCTION__, in_date);
	WeightRecord* weightsRecord = nil;
    
    sqlite3* db;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"weightRecords.sqlite"];
    
    NSDateFormatter* l_dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
	if(sqlite3_open([writableDBPath UTF8String], &db) == SQLITE_OK) 
    {
		const char* l_sqlQuery = "select weight, dateOfWeight, note from weightRecords where dateOfWeight < ? order by dateOfWeight desc limit 1";
		sqlite3_stmt* l_statement;
		if(sqlite3_prepare_v2(db, l_sqlQuery, -1, &l_statement, NULL) == SQLITE_OK) 
        {
            [l_dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            sqlite3_bind_text(l_statement, 1, [[l_dateFormatter stringFromDate:in_date] UTF8String], -1, SQLITE_STATIC);
            
			while(sqlite3_step(l_statement) == SQLITE_ROW) 
            {
				CGFloat l_weight = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 0)] floatValue];
				NSDate* l_date = [l_dateFormatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 1)]];
                NSString* l_note = [NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 2)];
                weightsRecord = [WeightRecord weightRecordWithDate:l_date noteString:l_note andWeightInKg:l_weight];
			}
		}
		sqlite3_finalize(l_statement);
	}
	sqlite3_close(db);
    return weightsRecord;
}

+ (WeightRecord*) firstWeightRecordAfterDate:(NSDate *)in_date
{
    NSLog(@"%s Fetching first weight record from the database after %@...", __PRETTY_FUNCTION__, in_date);
	WeightRecord* weightsRecord = nil;
    
    sqlite3* db;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"weightRecords.sqlite"];
    
    NSDateFormatter* l_dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
	if(sqlite3_open([writableDBPath UTF8String], &db) == SQLITE_OK) 
    {
		const char* l_sqlQuery = "select weight, dateOfWeight, note from weightRecords where dateOfWeight > ? order by dateOfWeight asc limit 1";
		sqlite3_stmt* l_statement;
		if(sqlite3_prepare_v2(db, l_sqlQuery, -1, &l_statement, NULL) == SQLITE_OK) 
        {
            [l_dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            sqlite3_bind_text(l_statement, 1, [[l_dateFormatter stringFromDate:in_date] UTF8String], -1, SQLITE_STATIC);
            
			while(sqlite3_step(l_statement) == SQLITE_ROW) 
            {
				CGFloat l_weight = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 0)] floatValue];
				NSDate* l_date = [l_dateFormatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 1)]];
                NSString* l_note = [NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 2)];
                weightsRecord = [WeightRecord weightRecordWithDate:l_date noteString:l_note andWeightInKg:l_weight];
			}
		}
		sqlite3_finalize(l_statement);
	}
	sqlite3_close(db);
    return weightsRecord;
}

+ (NSMutableArray*) estimateWeightRecordFromDate:(NSDate *)in_fromDate ToDate:(NSDate *)in_toDate
{
    NSMutableArray* weightRecords = [[self class] weightRecordFromDate:in_fromDate ToDate:in_toDate];
    return [[self class] arrayFillEstimateWeightTo:weightRecords FromDate:in_fromDate ToDate:in_toDate];
}

+ (NSMutableArray*) arrayFillEstimateWeightTo:(NSMutableArray*)weightRecords FromDate:(NSDate *)in_fromDate ToDate:(NSDate *)in_toDate
{
    // fill up date before the first available this month.
    WeightRecord* lastWeightRecordBefore = [[self class] lastWeightRecordBeforeDate: (NSDate *)in_fromDate];
    WeightRecord* firstWeightRecordAfter = [[self class] firstWeightRecordAfterDate: (NSDate *)in_toDate];
    if(lastWeightRecordBefore)
    {
        [weightRecords insertObject:lastWeightRecordBefore atIndex:0];
    }
    if(firstWeightRecordAfter)
    {    
        [weightRecords addObject:firstWeightRecordAfter];
    }
    NSMutableArray* result = [NSMutableArray array];
    
    WeightRecord* weightRecordBefore;
    WeightRecord* weightRecordAfter;
    
    for (NSDate* currentDate = in_fromDate; [currentDate compare:in_toDate] != NSOrderedDescending; currentDate = [NSDate dateWithTimeInterval:24*3600 sinceDate:currentDate]) 
    {
        NSArray* array = [WeightRecords findWeightRecordBeforeAndAfterWithDate:currentDate inRecords:weightRecords];
        NSLog(@"finding date before and after date: %@ result%@",currentDate, array);
        id before = [array objectAtIndex:0];
        id after = [array objectAtIndex:1];
        if (before != [NSNull null])
        {
            weightRecordBefore = before;
        }
        else 
        {
            weightRecordBefore = nil;
        }
        
        if (after != [NSNull null])
        {
            weightRecordAfter = after;
        }
        else 
        {
            weightRecordAfter = nil;
        }
        
        if ((weightRecordAfter == weightRecordBefore) && weightRecordAfter)
        {
            //found a existing
            [result addObject:weightRecordAfter];
        }
        else if(weightRecordBefore && weightRecordAfter)
        {
            //have both before and after one, but not hit
            int weightAfter = [KalDate DaysUsingDate:currentDate minusDate:weightRecordBefore.date];
            int weightBefore = [KalDate DaysUsingDate:weightRecordAfter.date minusDate:currentDate];
            float weight = (weightRecordAfter.weightInKg * weightAfter + weightRecordBefore.weightInKg * weightBefore)/(weightAfter + weightBefore);
            [result addObject:[WeightRecord estimateWeightRecordWithDate:currentDate andWeightInKg:weight]];
        }
        else if(weightRecordAfter)
        {
            [result addObject:[WeightRecord estimateWeightRecordWithDate:currentDate andWeightInKg:weightRecordAfter.weightInKg]];
        }
        else if(weightRecordBefore)
        {
            if ([currentDate compare:[[KalDate dateFromNSDate:[NSDate date]] NSDate]] == NSOrderedAscending)
            {
                [result addObject:[WeightRecord estimateWeightRecordWithDate:currentDate andWeightInKg:weightRecordBefore.weightInKg]];
            }
            else 
            {
                break;
            }
        }
        else 
        {
            break;
        }
    }
    
    return result;
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

+ (NSArray*) findWeightRecordBeforeAndAfterWithDate:(NSDate*)in_date inRecords:(NSMutableArray*)weightRecords
{
    NSLog(@"%@",in_date);
    WeightRecord* weightRecordBefore = nil;
    WeightRecord* weightRecordAfter = nil;
    
    for (WeightRecord* weightRecord in weightRecords)
    {
        int difference = [weightRecord.date timeIntervalSinceDate:in_date];
        if (difference < 0)
        {
            weightRecordBefore = weightRecord;
        }
        else if(difference == 0)
        {
            weightRecordBefore = weightRecord;
            weightRecordAfter = weightRecord;
            break;
        }
        else //(weightRecord.date > in_date)
        {
            if (!weightRecordAfter) 
            {
                weightRecordAfter = weightRecord;
                break;
            }
        }
    }
    NSMutableArray* array = [NSMutableArray array];
    if(weightRecordBefore)
    {
        [array addObject:weightRecordBefore];
    }
    else 
    {
        [array addObject:[NSNull null]];
    }
    
    if(weightRecordAfter)
    {
        [array addObject:weightRecordAfter];
    }
    else 
    {
        [array addObject:[NSNull null]];
    }
    return [NSArray arrayWithArray:array];
}

+ (float) firstDayWeight
{
    NSLog(@"%s Fetching first weight record from the database...", __PRETTY_FUNCTION__);
	WeightRecord* weightsRecord = nil;
    
    sqlite3* db;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"weightRecords.sqlite"];
    
    NSDateFormatter* l_dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
	if(sqlite3_open([writableDBPath UTF8String], &db) == SQLITE_OK) 
    {
		const char* l_sqlQuery = "select weight, dateOfWeight, note from weightRecords order by dateOfWeight asc limit 1";
		sqlite3_stmt* l_statement;
		if(sqlite3_prepare_v2(db, l_sqlQuery, -1, &l_statement, NULL) == SQLITE_OK) 
        {
            [l_dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
			while(sqlite3_step(l_statement) == SQLITE_ROW) 
            {
				CGFloat l_weight = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 0)] floatValue];
				NSDate* l_date = [l_dateFormatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 1)]];
                NSString* l_note = [NSString stringWithUTF8String:(char *)sqlite3_column_text(l_statement, 2)];
                weightsRecord = [WeightRecord weightRecordWithDate:l_date noteString:l_note andWeightInKg:l_weight];
			}
		}
		sqlite3_finalize(l_statement);
	}
	sqlite3_close(db);
    return weightsRecord.weightInKg;
}


// standard red [UIColor colorWithHue:0.005 saturation:0.863 brightness:0.84 alpha:1.000]
// standart green [UIColor colorWithHue:0.275 saturation:0.968 brightness:0.84 alpha:1.000]
+ (NSMutableArray*) absColorArrayForWeightRecords:(NSMutableArray*)weightRecordArray
{
    float threshold = 10;
    float zeroPointNumber = [[self class] firstDayWeight];
    NSMutableArray* colorArray = [NSMutableArray array];
    for (WeightRecord* weightRecord in weightRecordArray)
    {
        float difference = (weightRecord.weightInKg - zeroPointNumber);
        if (difference >= 0)
        {
            difference = difference/threshold;
            difference = difference > 1 ? 1 : difference;
            [colorArray addObject:[UIColor colorWithHue:0.005 saturation:(0.863 * difference) brightness:0.84 alpha:1.000]];
        }
        else
        {
            difference = -difference/threshold;
            difference = difference > 1 ? 1 : difference;
            [colorArray addObject:[UIColor colorWithHue:0.275 saturation:(0.968 * difference) brightness:0.84 alpha:1.000]];
        }
    }
    return colorArray;
}

@end
