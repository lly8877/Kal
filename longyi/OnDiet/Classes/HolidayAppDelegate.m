/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "HolidayAppDelegate.h"
#import "CalendarTableViewDataSource.h"
#import "EditWeightViewController.h"
#import "Kal.h"

@interface HolidayAppDelegate(privateMethods)

- (void) createEditableCopyOfDatabaseIfNeeded;
@end

@implementation HolidayAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    
    // Database related
    [self createEditableCopyOfDatabaseIfNeeded];
    /*
     *    Kal Initialization
     *
     * When the calendar is first displayed to the user, Kal will automatically select today's date.
     * If your application requires an arbitrary starting date, use -[KalViewController initWithSelectedDate:]
     * instead of -[KalViewController init].
     */
    kal = [[KalViewController alloc] init];
    kal.title = @"OnDiet";
    
    /*
     *    Kal Configuration
     *
     * This demo app includes 2 example datasources for the Kal component. Both datasources
     * contain 2009-2011 holidays, however, one datasource retrieves the data
     * from a remote web server using JSON while the other datasource retrieves the data
     * from a local Sqlite database. For this demo, I am going to set it up to just use
     * the Sqlite database.
     */
    kal.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)] autorelease];
    kal.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Weight" style:UIBarButtonItemStyleBordered target:self action:@selector(editToday)] autorelease];
    kal.delegate = self;
    dataSource = [[CalendarTableViewDataSource alloc] init];
    kal.dataSource = dataSource;
    
    // Setup the navigation stack and display it.
    navController = [[UINavigationController alloc] initWithRootViewController:kal];
    [window addSubview:navController.view];
    [window makeKeyAndVisible];
}

// Action handler for the navigation bar's right bar button item.
- (void)showAndSelectToday
{
    [kal showAndSelectDate:[NSDate date]];
}

- (void)editToday
{
    EditWeightViewController* editWeightVC = [[[EditWeightViewController alloc] initWithDate:[kal selectedDate]] autorelease];
    editWeightVC.delegate = kal;
    [navController presentModalViewController:editWeightVC animated:YES];
}
#pragma mark UITableViewDelegate protocol conformance

// Display a details screen for the selected holiday/row.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // detail.
}

#pragma mark -

- (void)dealloc
{
    [kal release];
    [dataSource release];
    [window release];
    [navController release];
    [super dealloc];
}

@end

@implementation HolidayAppDelegate(privateMethods)

- (void) createEditableCopyOfDatabaseIfNeeded;
{
    BOOL success;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"weightRecords.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
    {
        return;
    }
    NSString* defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"weightRecords.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    NSAssert(success, @"must be success");
}

@end