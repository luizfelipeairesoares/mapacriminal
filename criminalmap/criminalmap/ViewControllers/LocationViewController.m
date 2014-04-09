//
//  LocationViewController.m
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import "LocationViewController.h"
#import "LocationOps.h"
#import "ImageOps.h"
#import "MMPickerView.h"

@interface LocationViewController ()

@property(assign) BOOL isModusPickerShown;
@property(strong, nonatomic) NSMutableArray *modus;
@property(assign) int modusId;
@property(assign) double diff;
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
    if (appDelegate.arrayModus == nil) {
        [appDelegate selectModus];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    if (self.currentLocation == nil) {
        label.text = @"Cadastrar Local";
    } else {
        label.text = @"Editar Local";
    }
    [label sizeToFit];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolbar.tag = 8;
    toolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    [toolbar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.txtObs setInputAccessoryView:toolbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    //TODO: Adicionar botão de deletar
    [super viewDidAppear:animated];
    if (self.currentLocation != nil) {
        [self.txtName setText:self.currentLocation.locationName];
        [self.lblLatitude setText:[NSString stringWithFormat:@"%f", self.currentLocation.locationLat]];
        [self.lblLongitude setText:[NSString stringWithFormat:@"%f", self.currentLocation.locationLng]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLog(@"%@", self.currentLocation.locationDtCreated);
        NSString *date = [dateFormatter stringFromDate:self.currentLocation.locationDtCreated];
        NSLog(@"%@", date);
        [self.txtDate setText:date];
        if (self.currentLocation.locationDtModified == nil) {
            [txtModificacao setText:[dateFormatter stringFromDate:self.currentLocation.locationDtCreated]];
        } else {
            [txtModificacao setText:[dateFormatter stringFromDate:self.currentLocation.locationDtModified]];
        }
        NSString *modusName = @"";
        for (int i = 0; i < [appDelegate.arrayModus count]; i++) {
            if (self.currentLocation.modusId == [[[appDelegate.arrayModus objectAtIndex:i] objectForKey:@"modus_id"] intValue]) {
                modusName = [[appDelegate.arrayModus objectAtIndex:i] objectForKey:@"modus_name"];
                break;
            }
        }
        [lblTxtModus setText:modusName];
    } else {
        [self.lblLatitude setText:[NSString stringWithFormat:@"%f", appDelegate.locManager.location.coordinate.latitude]];
        [self.lblLongitude setText:[NSString stringWithFormat:@"%f", appDelegate.locManager.location.coordinate.longitude]];
        [img1 setHidden:TRUE];
        [img2 setHidden:TRUE];
        [img3 setHidden:TRUE];
        [noImages setHidden:FALSE];
        [btnAddPhoto setHidden:FALSE];
        [lblModificacao setHidden:TRUE];
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
        [lblModus setFrame:CGRectMake(lblModus.frame.origin.x, (lblModus.frame.origin.y + 70.0), lblModus.frame.size.width, lblModus.frame.size.height)];
        [lblTxtModus setFrame:CGRectMake(lblTxtModus.frame.origin.x, (lblTxtModus.frame.origin.y + 70.0), lblTxtModus.frame.size.width, lblTxtModus.frame.size.height)];
        [btnModus setFrame:CGRectMake(btnModus.frame.origin.x, (btnModus.frame.origin.y + 70.0), btnModus.frame.size.width, btnModus.frame.size.height)];
        [lblModificacao setFrame:CGRectMake(lblModificacao.frame.origin.x, (lblModificacao.frame.origin.y + 70.0), lblModificacao.frame.size.width, lblModificacao.frame.size.height)];
        [txtModificacao setFrame:CGRectMake(txtModificacao.frame.origin.x, (txtModificacao.frame.origin.y + 70.0), txtModificacao.frame.size.width, txtModificacao.frame.size.height)];
        [imgObs setFrame:CGRectMake(imgObs.frame.origin.x, (imgObs.frame.origin.y + 70.0), imgObs.frame.size.width, imgObs.frame.size.height)];
        [imgImages setFrame:CGRectMake(imgImages.frame.origin.x, (imgImages.frame.origin.y + 70.0), imgImages.frame.size.width, imgImages.frame.size.height)];
        self.diff = (lblModus.frame.origin.y - lblModificacao.frame.origin.y);
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
        if (self.currentLocation == nil) {
            self.currentLocation = [[Location alloc] init];
            self.currentLocation.locationDtCreated = selectedDate;
        } else {
            self.currentLocation.locationDtModified = [NSDate date];
        }
        NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"];
        self.currentLocation.userId = [[currentUser objectForKey:@"user_id"] intValue];
        self.currentLocation.locationName = self.txtName.text;
        self.currentLocation.locationLat = [self.lblLatitude.text doubleValue];
        self.currentLocation.locationLng = [self.lblLongitude.text doubleValue];
        self.currentLocation.modusId = self.modusId;
        if (self.txtObs.text != nil && ![self.txtObs.text isEqualToString:@""]) {
            self.currentLocation.locationText = self.txtObs.text;
        }
        LocationOps *locOps = [[LocationOps alloc] init];
        [locOps saveData:self.currentLocation completion:^(BOOL success, NSError *error) {
            if (success) {
                Location *insertedLocation = [[locOps selectLocation:self.currentLocation] objectAtIndex:0];
                if (img1.image != nil || img2.image != nil || img3.image != nil) {
                    ImageOps *imageOps = [[ImageOps alloc] init];
                    if (img1.image != nil) {
                        Image *image1 = [[Image alloc] init];
                        image1.imageUrl = img1Url;
                        image1.imageData = [[NSData alloc] initWithData:UIImagePNGRepresentation(img1.image)];
                        image1.locationId = insertedLocation.locationId;
                        [imageOps saveData:image1 completion:^(BOOL success, NSError *error) {
                            
                        }];
                    } else if (img2.image != nil) {
                        Image *image2 = [[Image alloc] init];
                        image2.imageUrl = img2Url;
                        image2.imageData = [[NSData alloc] initWithData:UIImagePNGRepresentation(img2.image)];
                        image2.locationId = insertedLocation.locationId;
                        [imageOps saveData:image2 completion:^(BOOL success, NSError *error) {
                            
                        }];
                    } else if (img3.image != nil) {
                        Image *image3 = [[Image alloc] init];
                        image3.imageUrl = img3Url;
                        image3.imageData = [[NSData alloc] initWithData:UIImagePNGRepresentation(img3.image)];
                        image3.locationId = insertedLocation.locationId;
                        [imageOps saveData:image3 completion:^(BOOL success, NSError *error) {
                            
                        }];
                    }
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Mapa Criminal" message:@"Local salvo com sucesso" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView setTag:1];
                [alertView show];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Mapa Criminal" message:@"Ocorreu um erro ao salvar o local. Por favor, tente novamente" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
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

- (IBAction)btnModusTouched:(id)sender {
    if (!self.isModusPickerShown) {
        if (self.modus == nil) {
            self.modus = [[NSMutableArray alloc] init];
            int i = 0;
            while (i < [appDelegate.arrayModus count]) {
                [self.modus addObject:[[appDelegate.arrayModus objectAtIndex:i] objectForKey:@"modus_name"]];
                i++;
            }
        }
        [MMPickerView showPickerViewInView:self.view withStrings:self.modus
                               withOptions:nil
                          actionCompletion:^(NSString *actionCompletion) {
                                    self.isModusPickerShown = NO;
                          }
                                completion:^(NSString *selectedString) {
                                    [lblTxtModus setText:selectedString];
                                    for (int i = 0; i < [appDelegate.arrayModus count]; i++) {
                                        if ([[[appDelegate.arrayModus objectAtIndex:i] objectForKey:@"modus_name"] isEqualToString:selectedString]) {
                                            self.modusId = [[[appDelegate.arrayModus objectAtIndex:i] objectForKey:@"modus_id"] intValue];
                                        }
                                    }
                                }
        ];
    }
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self dismissKeyboard:textField];
        [self showDatePicker];
    } else {
        [self dismissDatePicker:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self dismissKeyboard:textField];
}

- (IBAction)dismissKeyboard:(id)sender {
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
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 120.0), self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 120.0), self.view.frame.size.width, self.view.frame.size.height)];
}

#pragma mark - PickerView Delegate

- (void)showDatePicker {
    if (!pickerIsShown) {
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
        pickerIsShown = TRUE;
        [imgImages setHidden:TRUE];
        [imgObs setHidden:TRUE];
        [self.txtObs setHidden:TRUE];
        [UIView commitAnimations];
        if ([self.txtDate.text isEqualToString:@""]) {
            [self changeDate:datePicker];
        }
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
    pickerIsShown = FALSE;
    [imgImages setHidden:FALSE];
    [imgObs setHidden:FALSE];
    [self.txtObs setHidden:FALSE];
    [UIView commitAnimations];
}

- (void)removeViews:(id)sender {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
}

- (void)changeDate:(UIDatePicker *)sender {
    [self.txtDate setText:[NSDateFormatter localizedStringFromDate:sender.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle]];
    if (selectedDate == nil) {
        selectedDate = [[NSDate alloc] init];
    }
    selectedDate = sender.date;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([info count] > 0) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (image != nil) {
            if (img1.image == nil) {
                img1 = [[UIImageView alloc] init];
                [img1 setImage:image];
                img1Url = [info objectForKey:UIImagePickerControllerReferenceURL];
                [img1 sizeToFit];
            } else if (img2.image == nil) {
                img2 = [[UIImageView alloc] init];
                [img2 setImage:image];
                img2Url = [info objectForKey:UIImagePickerControllerReferenceURL];
                [img2 sizeToFit];
            } else if (img3.image == nil) {
                img3 = [[UIImageView alloc] init];
                [img3 setImage:image];
                img3Url = [info objectForKey:UIImagePickerControllerReferenceURL];
                [img1 sizeToFit];
            }
        }
        if (img1.image != nil && img2.image != nil && img3.image != nil) {
            [btnAddPhoto setHidden:TRUE];
        }
    }
    [self dismissViewControllerAnimated:YES completion:^() {
        [img1 setHidden:FALSE];
        [img2 setHidden:FALSE];
        [img3 setHidden:FALSE];
        [noImages setHidden:TRUE];
    }];
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

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1 && buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
        self.currentLocation = nil;
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
