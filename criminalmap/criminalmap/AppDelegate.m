//
//  AppDelegate.m
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Modus.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.locManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    
    [self checkDB];
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginView = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.window setRootViewController:loginView];
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

#pragma mark - Database

- (void)checkDB {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/criminal_map.db"];
    if ([fileManager fileExistsAtPath:dbPath]) {
        [self copyDatabaseToDocumentsFolder:fileManager dbPath:dbPath];
    }
}

- (void)copyDatabaseToDocumentsFolder:(NSFileManager *)fileMgr dbPath:(NSString *)dbPath {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"db"]) {
        NSError *err = nil;
        NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *copydbpath = [homeDir stringByAppendingPathComponent:@"criminal_map.db"];
        [fileMgr removeItemAtPath:copydbpath error:&err];
        if(![fileMgr copyItemAtPath:dbPath toPath:copydbpath error:&err]) {
            NSLog(@"Não foi possível copiar o banco de dados para a pasta de Documentos");
        } else {
            self.dbPath = copydbpath;
            [userDefaults setBool:YES forKey:@"db"];
        }
    } else {
        NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *copydbpath = [homeDir stringByAppendingPathComponent:@"criminal_map.db"];
        self.dbPath = copydbpath;
    }
}

- (void)selectModus {
    if (self.arrayModus == nil) {
        self.arrayModus = [[NSMutableArray alloc] init];
    }
    Modus *m = [[Modus alloc] init];
    self.arrayModus = [m selectAllModus];
}

@end
