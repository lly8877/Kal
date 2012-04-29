//
//  CalendarTableViewDataSource.m
//  OnDiet
//
//  Created by Longyi Li on 4/22/12.
//

#import "CalendarTableViewDataSource.h"
#import "WeightRecords.h"

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface CalendarTableViewDataSource ()

@property (nonatomic, retain) NSMutableArray* items;
@property (nonatomic, retain) NSMutableArray* weightRecords;

- (NSArray *)weightRecordsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (WeightRecord*) weightRecordAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation CalendarTableViewDataSource

@synthesize items = m_items;
@synthesize weightRecords = m_weightRecords;

+ (CalendarTableViewDataSource *)dataSource
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
    if ((self = [super init])) {
        self.items = [[[NSMutableArray alloc] init] autorelease];
        self.weightRecords = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (WeightRecord *)weightRecordAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.items objectAtIndex:indexPath.row];
}


#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    WeightRecord *weightRecord = [self weightRecordAtIndexPath:indexPath];
    cell.textLabel.text = [[NSNumber numberWithFloat:weightRecord.weightInKg] stringValue];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

#pragma mark Sqlite access

- (NSString *)databasePath
{
    return [[NSBundle mainBundle] pathForResource:@"weightRecords" ofType:@"db"];
}

- (void)loadWeightRecordsFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    self.weightRecords = [WeightRecords weightRecordFromDate:fromDate ToDate:toDate];
    [delegate loadedDataSource:self];
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    [self.weightRecords removeAllObjects];
    [self loadWeightRecordsFrom:fromDate to:toDate delegate:delegate];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    return [[self weightRecordsFrom:fromDate to:toDate] valueForKeyPath:@"date"];
}

- (NSArray* ) colorDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSArray* l_weightRecordArray = [self weightRecordsFrom:fromDate to:toDate];
    NSMutableArray* l_colorArray = [NSMutableArray array];
    NSMutableArray* l_dateArray = [NSMutableArray array];
    
    for(WeightRecord* l_weightRecord in l_weightRecordArray)
    {
        [l_dateArray addObject:l_weightRecord.date];
        if (l_weightRecord.weightInKg > 76)
        {
            [l_colorArray addObject:COLOR_ORANGE];
        }
        else 
        {
            [l_colorArray addObject:COLOR_LIGHT_BLUE];
        }
    }
    return [NSArray arrayWithObjects:l_dateArray, l_colorArray, nil];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    [self.items addObjectsFromArray:[self weightRecordsFrom:fromDate to:toDate]];
}

- (void)removeAllItems
{
    [self.items removeAllObjects];
}

- (CGFloat)WeightForDate:(NSDate *)in_Date
{
    NSArray* array = [self weightRecordsFrom:in_Date to:[in_Date dateByAddingTimeInterval: 3600*24]];
    if(array.count == 0)
        return 0;
    WeightRecord* weightRecord = [array objectAtIndex:0];
    return weightRecord.weightInKg;
}

#pragma mark -

- (NSArray *)weightRecordsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSMutableArray *matches = [NSMutableArray array];
    for (WeightRecord *weightRecord in self.weightRecords)
        if (IsDateBetweenInclusive(weightRecord.date, fromDate, toDate))
            [matches addObject:weightRecord];
    
    return matches;
}

- (void)dealloc
{
    [m_items release];
    [m_weightRecords release];
    [super dealloc];
}

@end
