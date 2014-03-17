//
//  LocationOps.m
//  criminalmap
//
//  Created by Luiz Soares on 14/03/14.
//
//

#import "LocationOps.h"

@implementation LocationOps

- (NSArray *)selectAllLocations {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *locations;
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL success = [fileMgr fileExistsAtPath:appDelegate.dbPath];
        if (success) {
            if(!(sqlite3_open([appDelegate.dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"Erro ao abrir o banco.");
                return nil;
            }
            NSString *sql = @"SELECT * FROM LOCATIONS";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement");
            } else {
                locations = [[NSMutableArray alloc] init];
                while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
                    char *dateCreated = (char *)sqlite3_column_text(sqlStatement, 0);
                    char *dateModified = (char *)sqlite3_column_text(sqlStatement, 1);
                    int uniqueId = sqlite3_column_int(sqlStatement, 2);
                    char *locImg1 = (char *)sqlite3_column_text(sqlStatement, 3);
                    char *locImg2 = (char *)sqlite3_column_text(sqlStatement, 4);
                    char *locImg3 = (char *)sqlite3_column_text(sqlStatement, 5);
                    char *locLat = (char *)sqlite3_column_text(sqlStatement, 6);
                    char *locLng = (char *)sqlite3_column_text(sqlStatement, 7);
                    char *locName = (char *)sqlite3_column_text(sqlStatement, 8);
                    int userId = sqlite3_column_int(sqlStatement, 9);
                    char *locTxt = (char *)sqlite3_column_text(sqlStatement, 10);
                    
                    Location *loc = [[Location alloc] init];
                    NSString *strDate = [NSString stringWithUTF8String:dateCreated];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                    loc.locationDtCreated = [dateFormatter dateFromString:strDate];
                    if (dateModified != nil) {
                        NSString *strModified = [NSString stringWithUTF8String:dateModified];
                        loc.locationDtModified = [dateFormatter dateFromString:strModified];
                    }
                    loc.locationId = uniqueId;
                    if (locImg1 != nil) {
                        
                    }
                    if (locImg2 != nil) {
                        
                    }
                    if (locImg3 != nil) {
                        
                    }
                    loc.locationLat = [[NSString stringWithUTF8String:locLat] doubleValue];
                    loc.locationLng = [[NSString stringWithUTF8String:locLng] doubleValue];
                    if (locTxt != nil) {
                        loc.locationText = [NSString stringWithUTF8String:locTxt];
                    }
                    loc.userId = userId;
                    loc.locationName = [NSString stringWithUTF8String:locName];
                    [locations addObject:loc];
                }
                sqlite3_finalize(sqlStatement);
                sqlite3_close(db);
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exceção: %@", [exception reason]);
    }
    @finally {
        return locations;
    }
}

- (void)saveData:(Location *)location completion:(void (^)(BOOL success, NSError *error))completion {
    @try {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL success = [fileMgr fileExistsAtPath:appDelegate.dbPath];
        if (success) {
            if(!(sqlite3_open([appDelegate.dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"Erro ao abrir o banco.");
                return;
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            NSString *formattedDate = [dateFormatter stringFromDate:location.locationDtCreated];
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO LOCATIONS(location_name, location_lat, location_lng, location_dt_criacao, user_id) VALUES (\"%@\", %f, %f, \"%@\", %d)", location.locationName, location.locationLat, location.locationLng, formattedDate, 1];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement");
            } else {
                if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
                    completion(true, nil);
                } else {
                    completion(false, nil);
                }
            }
            sqlite3_finalize(sqlStatement);
            sqlite3_close(db);
        }
    }
    @catch(NSException *exception) {
        
    }
}

- (void)updateData:(Location *)location {
    
}

- (void)deleteData:(Location *)location {
    
}

@end
