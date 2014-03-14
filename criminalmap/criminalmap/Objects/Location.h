//
//  Location.h
//  criminalmap
//
//  Created by Luiz Soares on 14/03/14.
//
//

#import <Foundation/Foundation.h>

@interface Location : NSObject {

}

@property(nonatomic) int locationId;
@property(strong, nonatomic) NSString *locationName;
@property(strong, nonatomic) NSString *locationText;
@property(nonatomic) double locationLat;
@property(nonatomic) double locationLng;
@property(strong, nonatomic) NSString *locationImg1;
@property(strong, nonatomic) NSString *locationImg2;
@property(strong, nonatomic) NSString *locationImg3;
@property(nonatomic) int userId;
@property(strong, nonatomic) NSDate *locationDtCreated;
@property(strong, nonatomic) NSDate *locationDtModified;

@end
