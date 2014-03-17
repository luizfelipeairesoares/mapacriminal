//
//  UserOps.h
//  criminalmap
//
//  Created by Luiz Soares on 14/03/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "User.h"
#import "AppDelegate.h"

@interface UserOps : NSObject {
    sqlite3 *db;
}

- (NSArray *)selectAllUsers;
- (void)saveData:(User *) user;
- (void)updateData:(User *) user;
- (void)deleteData:(User *) user;

@end
