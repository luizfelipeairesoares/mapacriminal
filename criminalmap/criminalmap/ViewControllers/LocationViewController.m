//
//  LocationViewController.m
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import "LocationViewController.h"
#import "LocationOps.h"

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
    if (self.currentLocation != nil) {
        [self.lblLatitude setText:[NSString stringWithFormat:@"%f", self.currentLocation.locationLat]];
        [self.lblLongitude setText:[NSString stringWithFormat:@"%f", self.currentLocation.locationLng]];
    } else {
        [self.lblLatitude setText:[NSString stringWithFormat:@"%f", appDelegate.locManager.location.coordinate.latitude]];
        [self.lblLongitude setText:[NSString stringWithFormat:@"%f", appDelegate.locManager.location.coordinate.longitude]];
        [img1 setHidden:TRUE];
        [img2 setHidden:TRUE];
        [img3 setHidden:TRUE];
        [noImages setHidden:FALSE];
        [btnAddPhoto setHidden:FALSE];
    }
}

- (void)viewDidLayoutSubviews {
    if (isiPhone5) {
        [name setFrame:CGRectMake(name.frame.origin.x, (name.frame.origin.y + 70.0), name.frame.size.width, name.frame.size.height)];
        [self.txtName setFrame:CGRectMake(self.txtName.frame.origin.x, (self.txtName.frame.origin.y + 70.0), self.txtName.frame.size.width, self.txtName.frame.size.height)];
        [latitude setFrame:CGRectMake(latitude.frame.origin.x, (latitude.frame.origin.y + 70.0), latitude.frame.size.width, latitude.frame.size.height)];
        [self.lblLatitude setFrame:CGRectMake(self.lblLatitude.frame.origin.x, (self.lblLatitude.frame.origin.y + 70.0), self.lblLatitude.frame.size.width, self.lblLatitude.frame.size.height)];
        [longitude setFrame:CGRectMake(longitude.frame.origin.x, (longitude.frame.origin.y + 70.0), longitude.frame.size.width, longitude.frame.size.height)];
        [self.lblLongitude setFrame:CGRectMake(self.lblLongitude.frame.origin.x, (self.lblLongitude.frame.origin.y + 70.0), self.lblLongitude.frame.size.width, self.lblLongitude.frame.size.height)];
        [data setFrame:CGRectMake(data.frame.origin.x, (data.frame.origin.y + 70.0), data.frame.size.width, data.frame.size.height)];
        [self.txtDate setFrame:CGRectMake(self.txtDate.frame.origin.x, (self.txtDate.frame.origin.y + 70.0), self.txtDate.frame.size.width, self.txtDate.frame.size.height)];
        [obs setFrame:CGRectMake(obs.frame.origin.x, (obs.frame.origin.y + 70.0), obs.frame.size.width, obs.frame.size.height)];
        [self.txtObs setFrame:CGRectMake(self.txtObs.frame.origin.x, (self.txtObs.frame.origin.y + 70.0), self.txtObs.frame.size.width, self.txtObs.frame.size.height)];
        [self.btnSalvar setFrame:CGRectMake(self.btnSalvar.frame.origin.x, (self.btnSalvar.frame.origin.y + 70.0), self.btnSalvar.frame.size.width, self.btnSalvar.frame.size.height)];
        [images setFrame:CGRectMake(images.frame.origin.x, (images.frame.origin.y + 70.0), images.frame.size.width, images.frame.size.height)];
        [img1 setFrame:CGRectMake(img1.frame.origin.x, (img1.frame.origin.y + 70.0), img1.frame.size.width, img1.frame.size.height)];
        [img2 setFrame:CGRectMake(img2.frame.origin.x, (img2.frame.origin.y + 70.0), img2.frame.size.width, img2.frame.size.height)];
        [img3 setFrame:CGRectMake(img3.frame.origin.x, (img3.frame.origin.y + 70.0), img3.frame.size.width, img3.frame.size.height)];
        [noImages setFrame:CGRectMake(noImages.frame.origin.x, (noImages.frame.origin.y + 70.0), noImages.frame.size.width, noImages.frame.size.height)];
        [btnAddPhoto setFrame:CGRectMake(btnAddPhoto.frame.origin.x, (btnAddPhoto.frame.origin.y + 70.0), btnAddPhoto.frame.size.width, btnAddPhoto.frame.size.height)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button

- (IBAction)btnSalvarTouched:(id)sender {
    if ([self checkBlankFields]) {
        Location *loc = [[Location alloc] init];
        loc.locationName = self.txtName.text;
        loc.locationLat = [self.lblLatitude.text doubleValue];
        loc.locationLng = [self.lblLongitude.text doubleValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        NSDate *dt = [dateFormatter dateFromString:self.txtDate.text];
        loc.locationDtCreated = dt;
        if (self.txtObs.text != nil && ![self.txtObs.text isEqualToString:@""]) {
            loc.locationText = self.txtObs.text;
        }
        LocationOps *locOps = [[LocationOps alloc] init];
        [locOps saveData:loc completion:^(BOOL success, NSError *error) {
            if (success) {
                [[[UIAlertView alloc] initWithTitle:@"Mapa Criminal" message:@"Local salvo com sucesso" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            } else {
                NSLog(@"%@", error);
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Mapa Criminal" message:@"Campos obrigatórios não preenchidos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (IBAction)btnAddPhotoTouched:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self showDatePicker];
        [self dismissKeyboard:textField];
    }
}

- (IBAction)dismissKeyboard:(id)sender {
//    [[self.view viewWithTag:9] removeFromSuperview];
    if ([sender class] == [UIBarButtonItem class]) {
        [self.txtObs resignFirstResponder];
    } else {
        [sender resignFirstResponder];
    }
}

#pragma mark - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolbar.tag = 8;
    toolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    [toolbar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolbar];
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
    [images setHidden:TRUE];
    [noImages setHidden:TRUE];
    [btnAddPhoto setHidden:TRUE];
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
    [images setHidden:FALSE];
    [noImages setHidden:FALSE];
    [btnAddPhoto setHidden:FALSE];
    [UIView commitAnimations];
}

- (void)removeViews:(id)sender {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
}

- (void)changeDate:(UIDatePicker *)sender {
    [self.txtDate setText:[NSDateFormatter localizedStringFromDate:sender.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([info count] > 0) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (image != nil) {
            [img1 setImage:image];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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
