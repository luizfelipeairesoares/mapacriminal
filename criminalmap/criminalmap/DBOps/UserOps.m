//
//  UserOps.m
//  criminalmap
//
//  Created by Luiz Soares on 14/03/14.
//
//

#import "UserOps.h"

@implementation UserOps

- (NSArray *)selectAllUsers {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *users;
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL success = [fileMgr fileExistsAtPath:appDelegate.dbPath];
        if (success) {
            if(!(sqlite3_open([appDelegate.dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"Erro ao abrir o banco.");
                return nil;
            }
            NSString *sql = @"SELECT * FROM USERS";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement");
            } else {
                users = [[NSMutableArray alloc] init];
                while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
                    char *dateCreated = (char *)sqlite3_column_text(sqlStatement, 0);
                    char *dateModified = (char *)sqlite3_column_text(sqlStatement, 1);
                    int uniqueId = sqlite3_column_int(sqlStatement, 2);
                    char *userName = (char *)sqlite3_column_text(sqlStatement, 3);
                    char *userNick = (char *)sqlite3_column_text(sqlStatement, 4);
                    char *userPass = (char *)sqlite3_column_text(sqlStatement, 5);
                    int policeId = sqlite3_column_int(sqlStatement, 6);
                    User *user = [[User alloc] init];
                    NSString *strDate = [NSString stringWithUTF8String:dateCreated];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                    user.userDtCreated = [dateFormatter dateFromString:strDate];
                    if (dateModified != nil) {
                        NSString *strModified = [NSString stringWithUTF8String:dateModified];
                        user.userDtModified = [dateFormatter dateFromString:strModified];
                    }
                    user.userId = uniqueId;
                    user.userFullname = [NSString stringWithUTF8String:userName];
                    user.userNick = [NSString stringWithUTF8String:userNick];
                    user.userPoliceId = policeId;
                    [users addObject:user];
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
        return users;
    }
}

- (void)saveData:(User *)user {
    
}

- (void)updateData:(User *)user {
    
}

- (void)deleteData:(User *)user {
    
}

@end
