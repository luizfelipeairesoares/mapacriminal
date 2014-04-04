//
//  Modus.h
//  criminalmap
//
//  Created by Luiz Soares on 04/04/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AppDelegate.h"

@interface Modus : NSObject {
    sqlite3 *db;
}

- (NSArray *)selectAllModus;

@end
