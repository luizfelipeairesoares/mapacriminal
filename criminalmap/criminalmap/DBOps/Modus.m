//
//  Modus.m
//  criminalmap
//
//  Created by Luiz Soares on 04/04/14.
//
//

#import "Modus.h"

@implementation Modus

- (NSArray *)selectAllModus {
    NSMutableArray *modusArray = nil;
    @try {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL success = [fileMgr fileExistsAtPath:appDelegate.dbPath];
        if (success) {
            if(!(sqlite3_open([appDelegate.dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"Erro ao abrir o banco.");
                return nil;
            }
            NSString *sql = @"SELECT * FROM MODUS";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement");
            } else {
                modusArray = [[NSMutableArray alloc] init];
                while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
                    int modusId = sqlite3_column_int(sqlStatement, 0);
                    char *modusName = (char *)sqlite3_column_text(sqlStatement, 1);
                    char *modusDescription = (char *)sqlite3_column_text(sqlStatement, 2);
                    NSString *modusI = [NSString stringWithFormat:@"%d", modusId];
                    NSString *modusN = [NSString stringWithUTF8String:modusName];
                    NSString *modusD = [NSString stringWithUTF8String:modusDescription];
                    NSDictionary *modus = [[NSDictionary alloc] initWithObjectsAndKeys:modusI, @"modus_id", modusN, @"modus_name", modusD, @"modus_description", nil];
                    [modusArray addObject:modus];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    @finally {
        return modusArray;
    }
}

@end
