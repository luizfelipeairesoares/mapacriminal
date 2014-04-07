//
//  LoginViewController.h
//  criminalmap
//
//  Created by Luiz Soares on 18/03/14.
//
//

#import <UIKit/UIKit.h>
#import "UserOps.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *txtLogin;
    IBOutlet UITextField *txtPass;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnEsqueci;
    IBOutlet UIButton *btnNovo;
}

@end
