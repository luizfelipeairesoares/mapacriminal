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
                    char *locLat = (char *)sqlite3_column_text(sqlStatement, 6);
                    char *locLng = (char *)sqlite3_column_text(sqlStatement, 7);
                    char *locName = (char *)sqlite3_column_text(sqlStatement, 8);
                    int userId = sqlite3_column_int(sqlStatement, 9);
                    char *locTxt = (char *)sqlite3_column_text(sqlStatement, 10);
                    
                    Location *loc = [[Location alloc] init];
                    NSString *strDateAndHour = [NSString stringWithUTF8String:dateCreated];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *d = [dateFormatter dateFromString:strDateAndHour];
                    loc.locationDtCreated = d;
                    if (dateModified != nil) {
                        NSString *strModified = [NSString stringWithUTF8String:dateModified];
                        loc.locationDtModified = [dateFormatter dateFromString:strModified];
                    }
                    loc.locationId = uniqueId;
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
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exceção: %@", [exception reason]);
    }
    @finally {
        sqlite3_close(db);
        return locations;
    }
}

- (NSArray *)selectLocation:(Location *)location {
    NSMutableArray *selectedLocations = nil;
    @try {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL success = [fileMgr fileExistsAtPath:appDelegate.dbPath];
        if (success) {
            if(!(sqlite3_open([appDelegate.dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"Erro ao abrir o banco.");
                return nil;
            }
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM LOCATIONS where user_id = %d and location_lat = %f and location_lng = %f", location.userId, location.locationLat, location.locationLng];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement");
            } else {
                selectedLocations = [[NSMutableArray alloc] init];
                while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
                    char *dateCreated = (char *)sqlite3_column_text(sqlStatement, 0);
                    char *dateModified = (char *)sqlite3_column_text(sqlStatement, 1);
                    int uniqueId = sqlite3_column_int(sqlStatement, 2);
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
                    loc.locationLat = [[NSString stringWithUTF8String:locLat] doubleValue];
                    loc.locationLng = [[NSString stringWithUTF8String:locLng] doubleValue];
                    if (locTxt != nil) {
                        loc.locationText = [NSString stringWithUTF8String:locTxt];
                    }
                    loc.userId = userId;
                    loc.locationName = [NSString stringWithUTF8String:locName];
                    [selectedLocations addObject:loc];
                }
                sqlite3_finalize(sqlStatement);
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    @finally {
//        sqlite3_close(db);
        return selectedLocations;
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
            Location *duplicity = [self verifyIfLocationExists:location];
            if (duplicity == nil) {
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO LOCATIONS(location_name, location_lat, location_lng, location_dt_criacao, location_text, user_id) VALUES (\"%@\", %f, %f, \"%@\", \"%@\", %d)", location.locationName, location.locationLat, location.locationLng, formattedDate, location.locationText, location.userId];
                sqlite3_stmt *sqlStatement;
                if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                    NSLog(@"Erro com o statement: %s", sqlite3_errmsg(db));
                    completion(false, nil);
                } else {
                    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
                        NSLog(@"Erro: %s", sqlite3_errmsg(db));
                        completion(true, nil);
                    } else {
                        completion(false, nil);
                    }
                }
                sqlite3_finalize(sqlStatement);
            } else {
                duplicity.userId = location.userId;
                duplicity.locationName = location.locationName;
                duplicity.locationText = location.locationText;
                [self updateData:duplicity completion:^(BOOL success, NSError *error) {
                    if (success) {
                        completion(true, nil);
                    } else {
                        completion(false, nil);
                    }
                }];
            }
        }
    }
    @catch(NSException *exception) {
        NSLog(@"%@", [exception reason]);
        completion(false, nil);
    }
    @finally {
        sqlite3_close(db);
    }
}

- (void)updateData:(Location *)location completion:(void (^)(BOOL success, NSError *error))completionBlock {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL success = [fileMgr fileExistsAtPath:appDelegate.dbPath];
        if (success) {
            if(!(sqlite3_open([appDelegate.dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"Erro ao abrir o banco.");
                return;
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];
            NSString *sql = [NSString stringWithFormat:@"UPDATE LOCATIONS SET location_name = \"%@\", location_text = \"%@\", location_dt_modificacao = \"%@\", user_id = %d WHERE location_id = %d", location.locationName, location.locationText, formattedDate, location.userId, location.locationId];
                sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement: %s", sqlite3_errmsg(db));
                completionBlock(false, nil);
            } else {
                if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
                    completionBlock(true, nil);
                } else {
                    completionBlock(false, nil);
                }
            }
            sqlite3_finalize(sqlStatement);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
        completionBlock(false, nil);
    }
    @finally {
        sqlite3_close(db);
    }
}

- (void)deleteData:(Location *)location completion:(void (^)(BOOL success, NSError *error))completionBlock {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL success = [fileMgr fileExistsAtPath:appDelegate.dbPath];
        if (success) {
            if(!(sqlite3_open([appDelegate.dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"Erro ao abrir o banco.");
                return;
            }
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM LOCATIONS WHERE location_id = %d", location.locationId];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement: %s", sqlite3_errmsg(db));
                completionBlock(false, nil);
            } else {
                if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
                    completionBlock(true, nil);
                } else {
                    completionBlock(false, nil);
                }
            }
            sqlite3_finalize(sqlStatement);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
        completionBlock(false, nil);
    }
    @finally {
        sqlite3_close(db);
    }
}

- (Location *)verifyIfLocationExists:(Location *)location {
    NSArray *loc = [self selectLocation:location];
    if (loc != nil && ([loc count] > 0) && ([loc objectAtIndex:0] != nil)) {
        [loc objectAtIndex:0];
    }
    return nil;
}

@end
