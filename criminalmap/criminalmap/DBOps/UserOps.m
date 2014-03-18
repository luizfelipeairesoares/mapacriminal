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
                    user.userPassword = [NSString stringWithUTF8String:userPass];
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

- (User *)selectUser:(NSString *)userLogin pass:(NSString *)userPass {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user = nil;
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL success = [fileMgr fileExistsAtPath:appDelegate.dbPath];
        if (success) {
            if(!(sqlite3_open([appDelegate.dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"Erro ao abrir o banco.");
                return nil;
            }
            NSString *sql = [NSString stringWithFormat:@"SELECT * from USERS where user_police_id = \"%@\" and user_pass = \"%@\"", userLogin, userPass];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement");
            } else {
                user = [[User alloc] init];
                while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
                    char *dateCreated = (char *)sqlite3_column_text(sqlStatement, 0);
                    char *dateModified = (char *)sqlite3_column_text(sqlStatement, 1);
                    int uniqueId = sqlite3_column_int(sqlStatement, 2);
                    char *userName = (char *)sqlite3_column_text(sqlStatement, 3);
                    char *userNick = (char *)sqlite3_column_text(sqlStatement, 4);
                    char *userPass = (char *)sqlite3_column_text(sqlStatement, 5);
                    int policeId = sqlite3_column_int(sqlStatement, 6);
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
                    user.userPassword = [NSString stringWithUTF8String:userPass];
                }
            }
            sqlite3_finalize(sqlStatement);
            sqlite3_close(db);
        }
    }
    @catch(NSException *exception) {
        NSLog(@"Exceção: %@", [exception reason]);
    }
    @finally {
        return user;
    }
}

- (void)saveData:(User *)user completion:(void (^)(BOOL, NSError *))completionBlock {
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
            NSString *formattedDate = [dateFormatter stringFromDate:user.userDtCreated];
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO USERS(user_name, user_nick, user_police_id, user_pass, user_dt_created) VALUES (\"%@\", \"%@\", %d, \"%@\", \"%@\")", user.userFullname, user.userNick, user.userPoliceId, user.userPassword, formattedDate];
            sqlite3_stmt *sqlStatement;
            char *errMsg;
            if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &sqlStatement, nil) != SQLITE_OK) {
                NSLog(@"Erro com o statement");
            } else {
                if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
                    completionBlock(true, nil);
                } else {
                    NSLog(@"%s", errMsg);
                    completionBlock(false, nil);
                }
            }
            sqlite3_finalize(sqlStatement);
            sqlite3_close(db);
        }
    }
    @catch(NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
}

- (void)updateData:(User *)user {
    
}

- (void)deleteData:(User *)user {
    
}

@end
