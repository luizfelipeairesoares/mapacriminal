//
//  Image.h
//  criminalmap
//
//  Created by Luiz Soares on 18/03/14.
//
//

#import <Foundation/Foundation.h>

@interface Image : NSObject {
    
}

@property(nonatomic) int imageId;
@property(nonatomic) int locationId;
@property(strong, nonatomic) NSString *imageUrl;
@property(strong, nonatomic) NSData *imageData;

@end
