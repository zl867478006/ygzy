//
//  CBus_LineDetailViewController.m
//  Bus
//
//  Created by Wenter Zhu on 11-1-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBus_LineDetailViewController.h"
#import "CBus_StationDetailViewController.h"
#import "CBus_LineDetailLineViewController.h"
#import "CDataContainer.h"

@implementation CBus_LineDetailViewController

@synthesize busLineDetailTableView,currentLineName;
@synthesize currentLineIndex;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																						   target:self
																						   action:@selector(AddLineToFavorite)];
	
	[[CDataContainer Instance] GetLineStationFromTableSequence:currentLineIndex];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.busLineDetailTableView reloadData];
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSInteger styleNum = [userDefault integerForKey:@"styleType"];
	
	switch (styleNum) {
		case 0:{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
			self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
			self.searchDisplayController.searchBar.barStyle = UIBarStyleDefault;
			break;
		}
		case 1:{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
			self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
			self.searchDisplayController.searchBar.barStyle = UIBarStyleBlackOpaque;
			break;
		}
	}
	
	[[CDataContainer Instance] GetLineStationFromTableSequence:currentLineIndex];
    [self.busLineDetailTableView reloadData];
	
	NSLog(@"-----Nav----%@",self.navigationController.viewControllers);
 }

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
 
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(void)AddLineToFavorite
{
	NSLog(@"-------addLineToFavorite---------%@---%d",currentLineName,currentLineIndex);
	
	for(NSString *lineName in [CDataContainer Instance].favoriteLineNameArray){
		if ([lineName isEqualToString:currentLineName]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收藏"
															message:[NSString stringWithFormat:@"%@ 已收藏",currentLineName]
														   delegate:self
												  cancelButtonTitle:@"确定"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			return;
		}
	}
	
	[[CDataContainer Instance] InsertFavoriteInfoToDatabase:0 
													AddName:currentLineName 
												   AddIndex:currentLineIndex
												 AddNameEnd:nil
												AddIndexEnd:0];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收藏"
													message:[NSString stringWithFormat:@"收藏 %@ 成功",currentLineName]
												   delegate:self
										  cancelButtonTitle:@"确定"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return currentLineName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [[CDataContainer Instance].sequenceNumArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // Configure the cell...
    cell.textLabel.text = [[CDataContainer Instance].stationNameArray objectAtIndex:[[CDataContainer Instance] GetBusLineSequenceByIndex:indexPath.row]-1];
	cell.imageView.image = [UIImage imageNamed:@"bus_table_stat.png"];

	return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
	CBus_LineDetailLineViewController *detailViewController = [[CBus_LineDetailLineViewController alloc] initWithNibName:@"CBus_LineDetailLineView" bundle:nil];
	
	detailViewController.currentStationName = [[CDataContainer Instance].stationNameArray objectAtIndex:[[CDataContainer Instance] GetBusLineSequenceByIndex:indexPath.row]-1];
	detailViewController.currentStationIndex = [[CDataContainer Instance].stationNameArray indexOfObject:detailViewController.currentStationName]+1;

	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
//	CBus_StationInfoViewController *detailViewController = [[CBus_StationInfoViewController alloc] initWithNibName:@"CBus_StationInfoView" bundle:nil];
//	
//	detailViewController.stationInfoName = [[CDataContainer Instance].stationNameArray objectAtIndex:
//											[[CDataContainer Instance] GetBusLineSequenceByIndex:indexPath.row]-1];
//	// Pass the selected object to the new view controller.
//	[self.navigationController pushViewController:detailViewController animated:YES];
//	[detailViewController release];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	self.busLineDetailTableView = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[busLineDetailTableView release];
    [super dealloc];
}


@end
