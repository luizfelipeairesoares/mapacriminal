//
//  User.h
//  criminalmap
//
//  Created by Luiz Soares on 14/03/14.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
    
}

@property(nonatomic) int userId;
@property(strong, nonatomic) NSString *userFullname;
@property(strong, nonatomic) NSString *userNick;
@property(strong, nonatomic) NSDate *userDtCreated;
@property(strong, nonatomic) NSDate *userDtModified;
@property(nonatomic) int userPoliceId;

@end
