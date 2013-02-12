//
//  EWMasterViewController.m
//  EasyWords
//
//  Created by Pham on 2/8/13.
//  Copyright (c) 2013 com.quangpham. All rights reserved.
//

#import "EWMasterViewController.h"
#import <Parse/Parse.h>

#import "EWAppDelegate.h"

@interface EWMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation EWMasterViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.className = @"Person";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        //self.paginationEnabled = YES;
        
        // The number of objects to show per page
        //self.objectsPerPage = 5;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"POST_SAVE_PERSON_DATA_SUCESSFUL" object:nil];
}

- (void)reloadTableData
{
    //[self.tableView reloadData];
    NSLog(@"reloadTableData");
    [self loadObjects];
}

- (void)uploadRandomImage
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    //self.storyboard
    UIStoryboard *storyBoard = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] init];
    UIViewController *vcToGo = [storyBoard instantiateViewControllerWithIdentifier:@"EWInsertViewController"];
    [self.navigationController pushViewController:vcToGo animated:YES];
}

#pragma mark - Table View
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}
 */
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
 */

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
 */

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (IBAction)buttonTapped:(id)sender {
    PFQueryTableViewController *tableController = [[PFQueryTableViewController alloc] initWithClassName:@"Person"];
    tableController.textKey = @"text";
    [self.navigationController pushViewController:tableController animated:YES];
    //[self presentViewController:tableController animated:YES completion:nil];
}

- (IBAction)fbLoginTapped:(id)sender {
}

- (IBAction)translateButtonDidTapped:(id)sender {
    UIStoryboard *storyBoard = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] init];
    UIViewController *vcToGo = [storyBoard instantiateViewControllerWithIdentifier:@"EWTranslateViewController"];
    [self.navigationController pushViewController:vcToGo animated:YES];
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    /*
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    */
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    //[query orderByAscending:@"priority"];
    
    return query;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [object objectForKey:@"firstname"], [object objectForKey:@"lastname"]];
    
    // Display image
    PFFile *imageFile = [object objectForKey:@"imageFile"];
    NSData *imageData = [imageFile getData];
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@", [object objectForKey:@"priority"]];
    
    return cell;
}
@end