//
//  ImageOps.m
//  criminalmap
//
//  Created by Luiz Soares on 18/03/14.
//
//

#import "ImageOps.h"
#import "AppDelegate.h"

@implementation ImageOps

- (NSArray *)selectAllImages {
    NSMutableArray *imagesArray = nil;
    @try {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL success = [fileMgr fileExistsAtPath:appDelegate.dbPath];
        if (success) {
            if(!(sqlite3_open([appDelegate.dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"Erro ao abrir o banco.");
                return nil;
            }
            NSString *sql = @"SELECT * FROM IMAGES";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement");
            } else {
                imagesArray = [[NSMutableArray alloc] init];
                while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
                    int imageId = sqlite3_column_int(sqlStatement, 0);
                    int locationId = sqlite3_column_int(sqlStatement, 1);
                    char *imageUrl = (char *)sqlite3_column_text(sqlStatement, 2);
                    int length = sqlite3_column_bytes(sqlStatement, 3);
                    NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(sqlStatement, 3) length:length];
                    Image *image = [[Image alloc] init];
                    image.imageId = imageId;
                    image.locationId = locationId;
                    image.imageUrl = [NSString stringWithUTF8String:imageUrl];
                    image.imageData = imageData;
                    [imagesArray addObject:image];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    @finally {
        return imagesArray;
    }
}

- (NSArray *)selectImagesFromLocation:(int)locationId {
    NSMutableArray *imagesArray = nil;
    @try {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL success = [fileMgr fileExistsAtPath:appDelegate.dbPath];
        if (success) {
            if(!(sqlite3_open([appDelegate.dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"Erro ao abrir o banco.");
                return nil;
            }
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM IMAGES where location_id = %d", locationId];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement");
            } else {
                imagesArray = [[NSMutableArray alloc] init];
                while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
                    int imageId = sqlite3_column_int(sqlStatement, 0);
                    int locationId = sqlite3_column_int(sqlStatement, 1);
                    char *imageUrl = (char *)sqlite3_column_text(sqlStatement, 2);
                    int length = sqlite3_column_bytes(sqlStatement, 3);
                    NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(sqlStatement, 3) length:length];
                    Image *image = [[Image alloc] init];
                    image.imageId = imageId;
                    image.locationId = locationId;
                    image.imageUrl = [NSString stringWithUTF8String:imageUrl];
                    image.imageData = imageData;
                    [imagesArray addObject:image];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    @finally {
        return imagesArray;
    }
}

- (void)saveData:(Image *)image completion:(void (^)(BOOL, NSError *))completionBlock {
    @try {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL success = [fileMgr fileExistsAtPath:appDelegate.dbPath];
        if (success) {
            if(!(sqlite3_open([appDelegate.dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"Erro ao abrir o banco.");
                return;
            }
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO IMAGES(location_id, image_url, image_blob) VALUES (%d, \"%@\", ?)", image.locationId, image.imageUrl];
            sqlite3_stmt *sqlStatement;
            char *errMsg;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement");
            } else {
                sqlite3_bind_blob(sqlStatement, 3, [image.imageData bytes], [image.imageData length], SQLITE_TRANSIENT);
                if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
                    completionBlock(true, nil);
                } else {
                    NSLog(@"%s", sqlite3_errmsg(db));
                    completionBlock(false, nil);
                }
            }
            sqlite3_finalize(sqlStatement);
            sqlite3_close(db);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
}

- (void)updateData:(Image *)image {
    
}

- (void)deleteData:(Image *)image {
    
}

@end
