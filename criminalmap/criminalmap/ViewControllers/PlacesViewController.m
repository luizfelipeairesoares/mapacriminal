//
//  PlacesViewController.m
//  criminalmap
//
//  Created by Luiz Soares on 13/03/14.
//
//

#import "PlacesViewController.h"
#import "PlacesCell.h"
#import "LocationViewController.h"

@interface PlacesViewController ()

@end

@implementation PlacesViewController

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
    LocationOps *locOps = [[LocationOps alloc] init];
    allLocations = [locOps selectAllLocations];
    if (allLocations == nil || [allLocations count] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Mapa Criminal" message:@"Não foi possível recuperar locais já cadastrados" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [table setHidden:TRUE];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PlacesCell";
    int storyIndex = [indexPath indexAtPosition:[indexPath length]-1];
    Location *location = [allLocations objectAtIndex:storyIndex];
    PlacesCell *cell = (PlacesCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.placeTitle setText:location.locationName];
    [cell.placeSubtitle setText:[NSString stringWithFormat:@"Latitude: %2.2f, Longitude: %2.2f", location.locationLat, location.locationLng]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int storyIndex = [indexPath indexAtPosition:[indexPath length]-1];
    Location *loc = [allLocations objectAtIndex:storyIndex];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationViewController *location = [storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];
    [location setTitle:@"Editar Local"];
    [location setCurrentLocation:loc];
    [self.navigationController pushViewController:location animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
