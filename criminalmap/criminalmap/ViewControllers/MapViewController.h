//
//  MapViewController.h
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    IBOutlet MKMapView *map;
    IBOutlet UILabel *lblLocalAprox;
    IBOutlet UIButton *btnCadastrar;
    IBOutlet UIButton *btnVerCadastrados;
    AppDelegate *appDelegate;
}

@end
