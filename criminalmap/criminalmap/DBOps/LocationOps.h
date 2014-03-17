//
//  LocationOps.h
//  criminalmap
//
//  Created by Luiz Soares on 14/03/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Location.h"
#import "AppDelegate.h"

@interface LocationOps : NSObject {
    sqlite3 *db;
}

- (NSArray *)selectAllLocations;
- (void)saveData:(Location *)location completion:(void (^)(BOOL success, NSError *error))completion;
- (void)updateData:(Location *) location;
- (void)deleteData:(Location *) location;

@end
