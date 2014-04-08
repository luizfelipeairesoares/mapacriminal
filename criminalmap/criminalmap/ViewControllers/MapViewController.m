//
//  MapViewController.m
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import "MapViewController.h"
#import "LocationViewController.h"
#import "PlacesViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.locManager setDelegate:self];
    [appDelegate.locManager startUpdatingLocation];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Mapa";
    [label sizeToFit];
    
    UIBarButtonItem *refreshLocation = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnRefinarTouched:)];
    [refreshLocation setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:refreshLocation];
    
    NSTimer *updateTimer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(btnRefinarTouched:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:updateTimer forMode:NSRunLoopCommonModes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    if (![lblLocalAprox.text isEqualToString:@""]) {
        [btnCadastrar setHidden:FALSE];
    } else {
        [btnCadastrar setHidden:TRUE];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.view.bounds.size.height != 568) {
        [btnVerCadastrados setFrame:CGRectMake(btnVerCadastrados.frame.origin.x, (btnVerCadastrados.frame.origin.y - 20.0), btnVerCadastrados.frame.size.width, btnVerCadastrados.frame.size.height)];
    } else {
        [btnVerCadastrados setFrame:CGRectMake(btnVerCadastrados.frame.origin.x, (btnVerCadastrados.frame.origin.y + 70.0), btnVerCadastrados.frame.size.width, btnVerCadastrados.frame.size.height)];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(appDelegate.locManager.location.coordinate, 100, 100);
    [map setRegion:region];

    //TODO: Add Hud
    
    [appDelegate.geocoder reverseGeocodeLocation:appDelegate.locManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil) {
            CLPlacemark *place = [placemarks objectAtIndex:0];
            NSDictionary *address = [place addressDictionary];
            [lblLocalAprox setText:[NSString stringWithFormat:@"%@, %@, %@, %@", [address objectForKey:@"Street"], [address objectForKey:@"SubLocality"] != nil ? [address objectForKey:@"SubLocality"] : @"", [address objectForKey:@"SubAdministrativeArea"] != nil ? [address objectForKey:@"SubAdministrativeArea"] : @"", [address objectForKey:@"City"]]];
            [btnCadastrar setHidden:FALSE];
        }
    }];
    [appDelegate.locManager stopUpdatingLocation];
}

#pragma mark - Buttons

- (IBAction)btnRefinarTouched:(id)sender {
    [appDelegate.locManager startUpdatingLocation];
}

- (IBAction)btnCadastrarTouched:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationViewController *location = [storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];
    [location setTitle:@"Cadastrar Local"];
    [self.navigationController pushViewController:location animated:YES];
}

- (IBAction)btnVerCadastradosTouched:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlacesViewController *places = [storyboard instantiateViewControllerWithIdentifier:@"PlacesViewController"];
    [self.navigationController pushViewController:places animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    NSLog(@"light");
    return UIStatusBarStyleLightContent;
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
