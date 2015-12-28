//
//  CBus_CurrentCityViewController.m
//  Bus
//
//  Created by Tide Zhang on 11-4-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBus_CurrentCityViewController.h"
#import "CDataContainer.h"

@implementation CBus_CurrentCityViewController

@synthesize lastIndexPath;
@synthesize selectCityName;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = [CDataContainer Instance].currentCityName;
	self.navigationItem.prompt = @"点击设置当前城市:";

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/**/
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	NSUserDefaults	*userDefault = [NSUserDefaults standardUserDefaults];
	
	if ([self.selectCityName isEqualToString:[CDataContainer Instance].currentCityName] || self.selectCityName == nil) {
		return;
	}
	else {
		
		[CDataContainer Instance].currentCityName = self.selectCityName;
		
		[userDefault setObject:[CDataContainer Instance].currentCityName forKey:@"currentCityName"];
		[userDefault synchronize];
		
		{
			[[CDataContainer Instance] CloseDatabase];
			[[CDataContainer Instance] clearData];
			[CDataContainer releaseInstance];
			[[CDataContainer Instance] viewDidLoad];
		}
		
		for (UINavigationController *controller in self.tabBarController.viewControllers) {
			[controller popToRootViewControllerAnimated:NO];
		}
	}
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/**/
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[CDataContainer Instance].downloadCitysArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSUInteger row = [indexPath row];
	NSUInteger oldRow = [lastIndexPath row];
	
    cell.textLabel.text = [[CDataContainer Instance].downloadCitysArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"bus_city_select.png"];
	
	cell.accessoryType = (row == oldRow && lastIndexPath != nil) ? 
	UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
	// Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}




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
   
	int newRow = [indexPath row];
	int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
	
	if (newRow != oldRow){
		UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastIndexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		lastIndexPath = indexPath;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSString *selectName = [[CDataContainer Instance].downloadCitysArray objectAtIndex:indexPath.row];
	
	
	BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *currentCity = [[NSString alloc] initWithFormat:@"%@%@",selectName,@".db"];
    NSString *writableDBPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:currentCity];
	NSLog(@"writableDBPath-----%@",writableDBPath);
    success = [fileManager fileExistsAtPath:writableDBPath];
	
    if (success){
		self.selectCityName = selectName;
		NSLog(@"-----数据库存在-----");
	}
	else {
		NSLog(@"-----数据库不存在-----");
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告"
														message:@"所选择的城市数据库不存在"
													   delegate:self cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		[[CDataContainer Instance].downloadCitysArray removeObject:selectName];
		
		NSUserDefaults	*userDefault = [NSUserDefaults standardUserDefaults];
		[userDefault setObject:[CDataContainer Instance].downloadCitysArray forKey:@"downloadCitys"];
		[userDefault synchronize];
		
		[self.tableView reloadData];
	}
	
	NSLog(@"currentCity-----%@-----",[CDataContainer Instance].currentCityName);
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[lastIndexPath release];
	[selectCityName release];
}


@end

