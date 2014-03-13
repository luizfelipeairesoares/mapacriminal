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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PlacesCell";
    int storyIndex = [indexPath indexAtPosition:[indexPath length]-1];
    PlacesCell *cell = (PlacesCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.placeTitle setText:[NSString stringWithFormat:@"Nome%d", storyIndex]];
    [cell.placeSubtitle setText:[NSString stringWithFormat:@"Subtitulo%d", storyIndex]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int storyIndex = [indexPath indexAtPosition:[indexPath length]-1];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationViewController *location = [storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];
    [location setTitle:@"Editar Local"];
    [self.navigationController pushViewController:location animated:YES];
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
