//
//  NewUserViewController.m
//  criminalmap
//
//  Created by Luiz Soares on 18/03/14.
//
//

#import "NewUserViewController.h"
#import "UserOps.h"

@interface NewUserViewController ()

@end

@implementation NewUserViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Control

- (IBAction)navControl:(id)sender {
    if ([sender tag] == 0) {
        [txtApelido becomeFirstResponder];
    } else if ([sender tag] == 1) {
        [txtPoliciaId becomeFirstResponder];
    } else if ([sender tag] == 2) {
        [txtSenha becomeFirstResponder];
    } else if ([sender tag] == 3) {
        [txtConfirmacaoSenha becomeFirstResponder];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y-50.0), self.view.frame.size.width, self.view.frame.size.height)];
    } else {
        [sender resignFirstResponder];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y+50.0), self.view.frame.size.width, self.view.frame.size.height)];
    }
}

#pragma mark - Button Control

- (IBAction)btnSalvarTouched:(id)sender {
    if ([self checkFields]) {
        User *newUser = [[User alloc] init];
        [newUser setUserFullname:txtNomeCompleto.text];
        [newUser setUserNick:txtApelido.text];
        [newUser setUserPoliceId:[txtPoliciaId.text intValue]];
        [newUser setUserDtCreated:[NSDate date]];
        [newUser setUserPassword:txtSenha.text];
        UserOps *userOps = [[UserOps alloc] init];
        [userOps saveData:newUser completion:^(BOOL success, NSError *error) {
            if (success) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mapa Criminal" message:@"Usuário criado com sucesso" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = 1;
                [alert show];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Mapa Criminal" message:@"Erro ao criar o usuário" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
        }];
    }
}

#pragma mark - Auxiliar Methods

- (BOOL)checkFields {
    if (![txtNomeCompleto.text isEqualToString:@""]) {
        if (![txtApelido.text isEqualToString:@""]) {
            if (![txtPoliciaId.text isEqualToString:@""]) {
                if (![txtSenha.text isEqualToString:@""] && ![txtConfirmacaoSenha.text isEqualToString:@""]) {
                    if ([txtSenha.text isEqualToString:txtConfirmacaoSenha.text]) {
                        return true;
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"Mapa Criminal" message:@"As senhas não são iguais" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    }
                }
            }
        }
    }
    [[[UIAlertView alloc] initWithTitle:@"Mapa Criminal" message:@"Verifique se todos os campos foram preenchidos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    return false;
}

#pragma mark = AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1 && buttonIndex == alertView.cancelButtonIndex) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
