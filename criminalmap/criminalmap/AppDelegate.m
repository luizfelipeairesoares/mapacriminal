//
//  AppDelegate.m
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import "AppDelegate.h"
#import "MapViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.locManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    NSString *databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"criminal_map.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == YES) {
		const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &db) == SQLITE_OK) {
            NSLog(@"DB OPENED SUCCESSFULLY!");
//            char *errMsg;
//            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
//            if (sqlite3_exec(db, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
//                status.text = @"Failed to create table";
//            }
//            sqlite3_close(db);
        } else {
            NSLog(@"DB DIDN'T OPEN!");
//            status.text = @"Failed to open/create database";
        }
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *mapView = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mapView];
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
