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

@interface LocationViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate> {
    AppDelegate *appDelegate;
    
    IBOutlet UILabel *name;
    IBOutlet UILabel *latitude;
    IBOutlet UILabel *longitude;
    IBOutlet UILabel *data;
    IBOutlet UILabel *obs;
    IBOutlet UILabel *images;
    IBOutlet UILabel *noImages;
    IBOutlet UIImageView *img1;
    NSString *img1Url;
    IBOutlet UIImageView *img2;
    NSString *img2Url;
    IBOutlet UIImageView *img3;
    NSString *img3Url;
    IBOutlet UIButton *btnAddPhoto;
    IBOutlet UILabel *lblModus;
    IBOutlet UILabel *lblTxtModus;
    IBOutlet UIButton *btnModus;
    IBOutlet UILabel *lblModificacao;
    IBOutlet UITextField *txtModificacao;
    IBOutlet UIImageView *imgObs;
    IBOutlet UIImageView *imgImages;
    
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
