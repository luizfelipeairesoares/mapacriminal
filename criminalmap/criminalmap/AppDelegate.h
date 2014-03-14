//
//  AppDelegate.h
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <sqlite3.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    sqlite3 *db;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

@end
