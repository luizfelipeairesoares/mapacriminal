//
//  NewUserViewController.h
//  criminalmap
//
//  Created by Luiz Soares on 18/03/14.
//
//

#import <UIKit/UIKit.h>

@interface NewUserViewController : UIViewController <UIAlertViewDelegate> {
    IBOutlet UITextField *txtNomeCompleto;
    IBOutlet UITextField *txtApelido;
    IBOutlet UITextField *txtPoliciaId;
    IBOutlet UITextField *txtSenha;
    IBOutlet UITextField *txtConfirmacaoSenha;
    IBOutlet UIButton *btnSalvar;
}

@end
