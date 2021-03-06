//
//  LoginViewController.m
//  criminalmap
//
//  Created by Luiz Soares on 18/03/14.
//
//

#import "LoginViewController.h"
#import "MapViewController.h"
#import "NewUserViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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

#pragma mark - Buttons

- (IBAction)btnLoginTouched:(id)sender {
    UserOps *userOps = [[UserOps alloc] init];
    User *u = [userOps selectUser:txtLogin.text pass:txtPass.text];
    if (u != nil) {
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setValue:[NSString stringWithFormat:@"%d", u.userId] forKey:@"user_id"];
        [userDict setValue:u.userFullname forKey:@"user_name"];
        [userDict setValue:u.userNick forKey:@"user_nick"];
        [userDict setValue:[NSString stringWithFormat:@"%d", u.userPoliceId] forKey:@"police_id"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:userDict forKey:@"CurrentUser"];
        [userDefaults synchronize];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MapViewController *mapView = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.navController = [[UINavigationController alloc] initWithRootViewController:mapView];
        [appDelegate.navController.navigationBar setBarTintColor:[UIColor colorWithRed:70/255.0 green:130.0/255.0 blue:180.0/255.0 alpha:1.]];
        [appDelegate.navController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [appDelegate.navController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.view.window setRootViewController:appDelegate.navController];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Mancha Criminal" message:@"Usuário não encontrado" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (IBAction)btnEsqueciTouched:(id)sender {
    
}

- (IBAction)btnNovoTouched:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewUserViewController *newUserView = [storyboard instantiateViewControllerWithIdentifier:@"NewUserViewController"];
    [self presentViewController:newUserView animated:YES completion:nil];
}

#pragma mark - text

- (IBAction)dismissKeyboard:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)goToNextField:(id)sender {
    [self dismissKeyboard:sender];
    [txtPass becomeFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y-50.0), self.view.frame.size.width, self.view.frame.size.height)];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y+50.0), self.view.frame.size.width, self.view.frame.size.height)];
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
