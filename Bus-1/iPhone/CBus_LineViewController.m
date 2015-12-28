//
//  CBus_LineViewController.m
//  Bus
//
//  Created by Wenter Zhu on 11-1-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBus_LineViewController.h"
#import "CBus_LineDetailViewController.h"
#import "CDataContainer.h"

@implementation CBus_LineViewController

@synthesize busLineTableView,filteredListContent;

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

/**/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.filteredListContent = [NSMutableArray arrayWithCapacity:[[CDataContainer Instance].lineNameArray count]];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.busLineTableView reloadData];

	NSLog(@"-----Nav------%@",self.navigationController.viewControllers);
	
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
	
	[self.busLineTableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated {
[super viewDidAppear:animated];
}
 
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return @"公交线路";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if(tableView == self.searchDisplayController.searchResultsTableView){
		return [filteredListContent count];
	}
	else {
		return [[CDataContainer Instance].lineNameArray count];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;

    // Configure the cell...

	if (tableView == self.searchDisplayController.searchResultsTableView){
		[[CDataContainer Instance] GetLineStationFromTableSequence:
		 [[CDataContainer Instance].lineNameArray indexOfObject:[filteredListContent objectAtIndex:indexPath.row]]];
		
		NSString *beginStr = [[CDataContainer Instance].stationNameArray objectAtIndex:
							  [[CDataContainer Instance] GetBusLineSequenceByIndex:0]-1];
		NSString *endStr = [[CDataContainer Instance].stationNameArray objectAtIndex:
							[[CDataContainer Instance] GetBusLineSequenceByIndex:[[CDataContainer Instance].sequenceNumArray count]-1]-1];
		
		NSString *detailStr = [[NSString alloc] initWithFormat:@"%@-->%@",beginStr,endStr];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
		cell.detailTextLabel.text = detailStr;
		[detailStr release];
		
		cell.textLabel.text = [filteredListContent objectAtIndex:indexPath.row];
	}
	else{
		[[CDataContainer Instance] GetLineStationFromTableSequence:indexPath.row];

		NSString *beginStr = [[CDataContainer Instance].stationNameArray objectAtIndex:
							  [[CDataContainer Instance] GetBusLineSequenceByIndex:0]-1];
		
		NSString *endStr = [[CDataContainer Instance].stationNameArray objectAtIndex:
							[[CDataContainer Instance] GetBusLineSequenceByIndex:[[CDataContainer Instance].sequenceNumArray count]-1]-1];
		
		NSString *detailStr = [[NSString alloc] initWithFormat:@"%@-->%@",beginStr,endStr];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
		cell.detailTextLabel.text = detailStr;
		[detailStr release];
		
		cell.textLabel.text = [[CDataContainer Instance].lineNameArray objectAtIndex:indexPath.row];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.imageView.image = [UIImage imageNamed:@"bus_table_line.png"];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Navigation logic may go here. Create and push another view controller.
	
	CBus_LineDetailViewController *detailViewController = [[CBus_LineDetailViewController alloc] initWithNibName:@"CBus_LineDetailView" bundle:nil];

	// Pass the selected object to the new view controller.
	
	if (tableView == self.searchDisplayController.searchResultsTableView){		
		detailViewController.currentLineName = [filteredListContent objectAtIndex:indexPath.row];
		detailViewController.currentLineIndex = [[CDataContainer Instance].lineNameArray indexOfObject:[filteredListContent objectAtIndex:indexPath.row]];
	}
	else{
		detailViewController.currentLineName = [[CDataContainer Instance].lineNameArray objectAtIndex:indexPath.row];
		detailViewController.currentLineIndex = indexPath.row;
	}

	[self.navigationController pushViewController:detailViewController animated:YES];

	[detailViewController release];
	 
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	// First clear the filtered array.
	[self.filteredListContent removeAllObjects]; 
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */

	for (int i = 0; i < [[CDataContainer Instance].lineNameArray count]; i++){
		NSString * searchInfo = [[CDataContainer Instance].lineNameArray objectAtIndex:i];
		
		NSComparisonResult result = [searchInfo compare:searchText 
												options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
												  range:NSMakeRange(0, [searchText length])];
		
		if (result == NSOrderedSame){
			[self.filteredListContent addObject:searchInfo];
		}
	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

/**/
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
    self.busLineTableView = nil;
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[busLineTableView release];
	[filteredListContent release];
    [super dealloc];
}


@end
