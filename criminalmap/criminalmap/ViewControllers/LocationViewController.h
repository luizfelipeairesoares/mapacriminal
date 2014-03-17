//
//  LocationViewController.h
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Location.h"

@interface LocationViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate> {
    AppDelegate *appDelegate;
    
    IBOutlet UILabel *name;
    IBOutlet UILabel *latitude;
    IBOutlet UILabel *longitude;
    IBOutlet UILabel *data;
    IBOutlet UILabel *obs;
    IBOutlet UILabel *images;
    IBOutlet UILabel *noImages;
    IBOutlet UIImageView *img1;
    IBOutlet UIImageView *img2;
    IBOutlet UIImageView *img3;
    IBOutlet UIButton *btnAddPhoto;
    
    NSDate *selectedDate;
    BOOL pickerIsShown;
}

@property(strong, nonatomic) IBOutlet UITextField *txtName;
@property(strong, nonatomic) IBOutlet UILabel *lblLatitude;
@property(strong, nonatomic) IBOutlet UILabel *lblLongitude;
@property(strong, nonatomic) IBOutlet UITextField *txtDate;
@property(strong, nonatomic) IBOutlet UITextView *txtObs;
@property(strong, nonatomic) IBOutlet UIButton *btnSalvar;
@property(strong, nonatomic) Location *currentLocation;

@end
