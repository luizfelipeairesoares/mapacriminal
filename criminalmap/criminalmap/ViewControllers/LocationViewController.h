//
//  LocationViewController.h
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LocationViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate> {
    AppDelegate *appDelegate;
}

@property(strong, nonatomic) IBOutlet UILabel *lblLatitude;
@property(strong, nonatomic) IBOutlet UILabel *lblLongitude;
@property(strong, nonatomic) IBOutlet UITextField *txtDate;
@property(strong, nonatomic) IBOutlet UITextView *txtObs;
@property(strong, nonatomic) IBOutlet UIButton *btnSalvar;

@end
