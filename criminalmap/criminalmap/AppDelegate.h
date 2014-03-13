//
//  AppDelegate.h
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

@end
