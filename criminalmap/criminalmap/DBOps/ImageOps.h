//
//  ImageOps.h
//  criminalmap
//
//  Created by Luiz Soares on 18/03/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Image.h"

@interface ImageOps : NSObject {
    sqlite3 *db;
}

- (NSArray *)selectAllImages;
- (NSArray *)selectImagesFromLocation:(int)locationId;
- (void)saveData:(Image *)image completion:(void (^)(BOOL success, NSError *error))completionBlock;
- (void)updateData:(Image *) image;
- (void)deleteData:(Image *) image;

@end
