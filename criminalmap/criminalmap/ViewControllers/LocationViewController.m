//
//  LocationViewController.m
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

#pragma mark - View Lifecycle

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
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolbar.tag = 8;
    toolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    [toolbar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.txtObs setInputAccessoryView:toolbar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.lblLatitude setText:[NSString stringWithFormat:@"%2.5f", appDelegate.locManager.location.coordinate.latitude]];
    [self.lblLongitude setText:[NSString stringWithFormat:@"%2.5f", appDelegate.locManager.location.coordinate.longitude]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button

- (IBAction)btnSalvarTouched:(id)sender {
    if ([self checkBlankFields]) {
        //save;
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Mapa Criminal" message:@"Campos obrigatórios não preenchidos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self showDatePicker];
    [self dismissKeyboard:textField];
}

- (IBAction)dismissKeyboard:(id)sender {
    [[self.view viewWithTag:8] removeFromSuperview];
    [self.txtObs resignFirstResponder];
}

#pragma mark - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
}

#pragma mark - PickerView Delegate

- (void)showDatePicker {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolbar.tag = 9;
    toolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolbar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolbar];

    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    datePicker.tag = 10;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    [UIView beginAnimations:@"SlideIn" context:nil];
    toolbar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    [self.btnSalvar setHidden:TRUE];
    [UIView commitAnimations];
    if ([self.txtDate.text isEqualToString:@""]) {
        [self changeDate:datePicker];
    }
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    
    [UIView beginAnimations:@"SlideOut" context:nil];
    [self.view viewWithTag:9].frame = datePickerTargetFrame;
    [self.view viewWithTag:10].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [self.btnSalvar setHidden:FALSE];
    [UIView commitAnimations];
}

- (void)removeViews:(id)sender {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
}

- (void)changeDate:(UIDatePicker *)sender {
    [self.txtDate setText:[NSDateFormatter localizedStringFromDate:sender.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]];
}

#pragma mark - Auxiliar Methods

- (BOOL)checkBlankFields {
    if (![self.lblLatitude.text isEqualToString:@""] &&
         ![self.lblLongitude.text isEqualToString:@""] &&
          ![self.txtDate.text isEqualToString:@""]) {
        return true;
    }
    return false;
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
