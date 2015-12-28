//
//  CBus_StatToStatViewController.m
//  Bus
//
//  Created by Wenter Zhu on 11-1-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBus_StatToStatViewController.h"
#import "CBus_LineDetailViewController.h"
#import "CBus_StationDetailViewController.h"
#import "CDataContainer.h"


@implementation CBus_StatToStatViewController

@synthesize busStatToStatTableView,beginFilteredListContent,endFilteredListContent;
@synthesize beginSearchBar, endSearchBar, stationPickView;
@synthesize isJumpToStat;

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
	
	returnKeyBordBtn = [[UIBarButtonItem alloc] initWithTitle:@"收起键盘"	style:UIBarButtonItemStylePlain 
																		target:self
																	    action:@selector(HideKeyBoard:)];
	
	self.navigationItem.rightBarButtonItem = nil;// returnKeyBord;
	
	self.beginFilteredListContent = [NSMutableArray arrayWithArray:[CDataContainer Instance].stationNameArray];
	self.endFilteredListContent = [NSMutableArray arrayWithArray:[CDataContainer Instance].stationNameArray];

	isSearchBegin = NO;
	isSearchEndBegin = NO;
	isJumpToStat = NO;
	
	ifSelectedPickerString = [[NSString alloc] init];
	ifSelectedPickEndString = [[NSString alloc] init];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.busStatToStatTableView reloadData];
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSInteger styleNum = [userDefault integerForKey:@"styleType"];
	
	switch (styleNum){
		case 0:{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
			self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
			self.beginSearchBar.barStyle = UIBarStyleDefault;
			self.endSearchBar.barStyle = UIBarStyleDefault;
			break;
		}
		case 1:{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
			self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
			self.beginSearchBar.barStyle = UIBarStyleBlackOpaque;
			self.endSearchBar.barStyle = UIBarStyleBlackOpaque;
			break;
		}
	}
	
	self.navigationItem.rightBarButtonItem = nil;
	
	stationType = ENoneStationType;

	[stationPickView reloadAllComponents];
	
	if(isJumpToStat){
		CBus_StationDetailViewController *detailViewController = [[CBus_StationDetailViewController alloc] initWithNibName:@"CBus_StationDetailView" bundle:nil];
		detailViewController.currentStationName = [[CDataContainer Instance].stationNameArray objectAtIndex:currentBeginIndex];
		detailViewController.currentStationIndex = currentBeginIndex+1;
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
		isJumpToStat = NO;
	}
	
	
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	
	beginSearchBar.text = @"";
	endSearchBar.text = @"";
}

 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
 // Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)HideKeyBoard:(id)sender{
	NSLog(@"------HideKeyBoard------");
	self.navigationItem.rightBarButtonItem = nil;
	
	beginSearchBar.text = @"";
	endSearchBar.text = @"";

	stationPickView.hidden = YES;
	[currentSearchBar resignFirstResponder];
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return @"站站查询";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [[CDataContainer Instance].stationNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;

    // Configure the cell...
	cell.textLabel.text = [[CDataContainer Instance].stationNameArray objectAtIndex:indexPath.row];
	cell.imageView.image = [UIImage imageNamed:@"bus_table_stat.png"];

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
	CBus_StationDetailViewController *detailViewController = [[CBus_StationDetailViewController alloc] initWithNibName:@"CBus_StationDetailView" bundle:nil];
	
	detailViewController.currentStationName = [[CDataContainer Instance].stationNameArray objectAtIndex:indexPath.row];
	detailViewController.currentStationIndex = indexPath.row+1;

	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
//	CBus_StationInfoViewController *detailViewController = [[CBus_StationInfoViewController alloc] initWithNibName:@"CBus_StationInfoView" bundle:nil];
//	
//	detailViewController.stationInfoName = [[CDataContainer Instance].stationNameArray objectAtIndex:indexPath.row];
//	// Pass the selected object to the new view controller.
//	[self.navigationController pushViewController:detailViewController animated:YES];
//	[detailViewController release];
}
#pragma mark -
#pragma mark Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	if (component == kBeginStationComponent){
		if ([beginSearchBar.text isEqualToString:@""]){
			return [[CDataContainer Instance].stationNameArray count];
		}
		if (stationType == EBeginStationType){
			return[beginFilteredListContent count];
		}
		else{
			return [[CDataContainer Instance].stationNameArray count];
		}
	}
	else if(component == kEndStationComponent){
		if ([endSearchBar.text isEqualToString:@""]){
			return [[CDataContainer Instance].stationNameArray count];
		}
		if (stationType == EEndStationType){
			return[endFilteredListContent count];
		}
		else {
			return [[CDataContainer Instance].stationNameArray count];
		}
	}
	
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	if (component == kBeginStationComponent){
		if ([beginSearchBar.text isEqualToString:@""]){
			return [[CDataContainer Instance].stationNameArray objectAtIndex:row];
		}
		if (stationType == EBeginStationType){
			return[beginFilteredListContent objectAtIndex:row];
		}
		else {
			return [[CDataContainer Instance].stationNameArray objectAtIndex:row];
		}
	}
	else if(component == kEndStationComponent){
		if ([endSearchBar.text isEqualToString:@""]){
			return [[CDataContainer Instance].stationNameArray objectAtIndex:row];
		}
		if (stationType == EEndStationType){
			return[endFilteredListContent objectAtIndex:row];
		}
		else {
			return [[CDataContainer Instance].stationNameArray objectAtIndex:row];
		}
	}
	
	return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	if (component == kBeginStationComponent){
		currentBeginIndex = row;
		
		if ([beginSearchBar.text isEqualToString:@""]){
			isSearchBegin = NO;
			ifSelectedPickerString = [[CDataContainer Instance].stationNameArray objectAtIndex:row];
			beginSearchBar.text = [[CDataContainer Instance].stationNameArray objectAtIndex:row];
		}
		else if (stationType == EBeginStationType){
			ifSelectedPickerString = [beginFilteredListContent objectAtIndex:row];
			beginSearchBar.text = [beginFilteredListContent objectAtIndex:row];
		}
		else {
			ifSelectedPickerString = [[CDataContainer Instance].stationNameArray objectAtIndex:row];
			beginSearchBar.text = [[CDataContainer Instance].stationNameArray objectAtIndex:row];
		}
	}
	else if(component == kEndStationComponent){
		currentEndIndex = row;
		
		if ([endSearchBar.text isEqualToString:@""]){
			isSearchEndBegin = NO;
			ifSelectedPickEndString = [[CDataContainer Instance].stationNameArray objectAtIndex:row];
			endSearchBar.text = [[CDataContainer Instance].stationNameArray objectAtIndex:row];
		}
		else if (stationType == EEndStationType){
			ifSelectedPickEndString = [endFilteredListContent objectAtIndex:row];
			endSearchBar.text = [endFilteredListContent objectAtIndex:row];
		}
		else{
			ifSelectedPickEndString = [[CDataContainer Instance].stationNameArray objectAtIndex:row];
			endSearchBar.text = [[CDataContainer Instance].stationNameArray objectAtIndex:row];
		}
	}
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
#pragma mark SearchBarText delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	NSLog(@"------searchBarTextDidBeginEditing---");
	stationPickView.hidden = NO;
	self.navigationItem.rightBarButtonItem = returnKeyBordBtn;
	currentSearchBar = searchBar;
	
	if (currentSearchBar == beginSearchBar){
		NSLog(@"---------Type------EBeginStationType");
		stationType = EBeginStationType;
	}
	else{
		NSLog(@"---------Type------EEndStationType");
		stationType = EEndStationType;
	}
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
	NSLog(@"------searchBarTextDidEndEditing---");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	NSLog(@"--------SearchBar_text Changed--------");

	if(searchBar == beginSearchBar)
	{
		if ([ifSelectedPickerString isEqualToString:searchText]){
			return;
		}
		if (stationType == EBeginStationType){
			isSearchBegin = YES;
			[self filterContentForSearchText:searchText];
			[stationPickView reloadAllComponents];
		}
	}
	else if(searchBar == endSearchBar){
		if ([ifSelectedPickEndString isEqualToString:searchText]){
			return;
		}
		if (stationType == EEndStationType){
			isSearchEndBegin = YES;
			[self filterContentForSearchText:searchText];
			[stationPickView reloadAllComponents];
		}
	}
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	NSLog(@"------searchBarSearchButtonClicked---");
	
	CBus_StationDetailViewController *detailViewController = [[CBus_StationDetailViewController alloc] initWithNibName:@"CBus_StationDetailView" bundle:nil];
	
	if ((![beginSearchBar.text isEqualToString:@""])&&(![endSearchBar.text isEqualToString:@""])){
		NSLog(@"------站站查询------");

		if (isSearchBegin){
			detailViewController.beginStationName = [beginFilteredListContent objectAtIndex:currentBeginIndex];
			detailViewController.beginStationIndex = [[CDataContainer Instance].stationNameArray indexOfObject:[beginFilteredListContent objectAtIndex:currentBeginIndex]]+1;
		}
		else {
			detailViewController.beginStationName = [[CDataContainer Instance].stationNameArray objectAtIndex:currentBeginIndex];
			detailViewController.beginStationIndex = currentBeginIndex+1;
		}
		
		if (isSearchEndBegin){
			detailViewController.endStationName = [endFilteredListContent objectAtIndex:currentEndIndex];
			detailViewController.endStationIndex = [[CDataContainer Instance].stationNameArray indexOfObject:[endFilteredListContent objectAtIndex:currentEndIndex]]+1;
		}
		else {
			detailViewController.endStationName = [[CDataContainer Instance].stationNameArray objectAtIndex:currentEndIndex];
			detailViewController.endStationIndex = currentEndIndex+1;
		}
		
		detailViewController.isStatToStat = YES;
	}
	else if (stationType == EBeginStationType){
		NSLog(@"------始站查询------");

		if (isSearchBegin){
			detailViewController.currentStationName = [beginFilteredListContent objectAtIndex:currentBeginIndex];
			detailViewController.currentStationIndex = [[CDataContainer Instance].stationNameArray indexOfObject:[beginFilteredListContent objectAtIndex:currentBeginIndex]]+1;
		}
		else {
			detailViewController.currentStationName = [[CDataContainer Instance].stationNameArray objectAtIndex:currentBeginIndex];
			detailViewController.currentStationIndex = currentBeginIndex+1;
		}
		
		detailViewController.isStatToStat = NO;
	}
	else if(stationType == EEndStationType){
		NSLog(@"------尾站查询------");

		if (isSearchEndBegin){
			detailViewController.currentStationName = [endFilteredListContent objectAtIndex:currentEndIndex];
			detailViewController.currentStationIndex = [[CDataContainer Instance].stationNameArray indexOfObject:[endFilteredListContent objectAtIndex:currentEndIndex]]+1;
		}
		else{
			detailViewController.currentStationName = [[CDataContainer Instance].stationNameArray objectAtIndex:currentEndIndex];
			detailViewController.currentStationIndex = currentEndIndex+1;
		}
		
		detailViewController.isStatToStat = NO;
	}
	
	[currentSearchBar resignFirstResponder];
	 stationPickView.hidden = YES;
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

#pragma mark -
#pragma mark Search Methods

- (void)filterContentForSearchText:(NSString*)searchText;{
	//Update the filtered array based on the search text and scope.
	// First clear the filtered array.
	
	if (stationType == EBeginStationType){
		[self.beginFilteredListContent removeAllObjects]; 

		for (int i = 0; i < [[CDataContainer Instance].stationNameArray count]; i++){
			NSString *searchNameInfo = [[CDataContainer Instance].stationNameArray objectAtIndex:i];
			NSString *searchPYInfo = [[CDataContainer Instance].stationPYArray objectAtIndex:i];

			NSComparisonResult result = [searchNameInfo compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			NSComparisonResult resultPY = [searchPYInfo compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			
			if (result == NSOrderedSame || resultPY == NSOrderedSame){
				[self.beginFilteredListContent addObject:searchNameInfo];
			}
		}
	}
	else if(stationType == EEndStationType){
		[self.endFilteredListContent removeAllObjects];

		for (int i = 0; i < [[CDataContainer Instance].stationNameArray count]; i++){
			NSString *searchNameInfo = [[CDataContainer Instance].stationNameArray objectAtIndex:i];
			NSString *searchPYInfo = [[CDataContainer Instance].stationPYArray objectAtIndex:i];
			
			NSComparisonResult result = [searchNameInfo compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			NSComparisonResult resultPY = [searchPYInfo compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			
			if (result == NSOrderedSame || resultPY == NSOrderedSame){
				[self.endFilteredListContent addObject:searchNameInfo];
			}
		}
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
//    self.busStatToStatTableView = nil;

}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[busStatToStatTableView release];
	[beginSearchBar release];
	[endSearchBar release];
	[currentSearchBar release];
	[stationPickView release];
	[beginFilteredListContent release];
	[endFilteredListContent release];
	[returnKeyBordBtn release];

    [super dealloc];
}


@end
