//
//  PlacesViewController.h
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import <UIKit/UIKit.h>
#import "LocationOps.h"

@interface PlacesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *table;
    NSArray *allLocations;
}

@end
