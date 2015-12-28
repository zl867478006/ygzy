//
//  CSettingViewController.m
//  Bus
//
//  Created by Wenter Zhu on 11-1-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CSettingViewController.h"
#import "CBus_CityDataViewController.h"
#import "CBus_InfoViewController.h"
#import "CBus_CurrentCityViewController.h"
#import "CDataContainer.h"

@implementation CSettingViewController

@synthesize settingTableView;
@synthesize cityNumLab;
@synthesize currentCityLab;


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
	
	UIBarButtonItem *returnInfoBtn = [[UIBarButtonItem alloc] initWithTitle:@"反馈" style:UIBarButtonItemStylePlain
													   target:self action:@selector(SendEmail:)];
	
	self.navigationItem.rightBarButtonItem = returnInfoBtn;// returnKeyBord;
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(170, 16, 100, 20)];
	label.font = [UIFont systemFontOfSize:13];
	label.textColor = [UIColor darkGrayColor];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentRight;
	self.cityNumLab = label;
	[label release];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(130, 16, 140, 20)];
	label.font = [UIFont systemFontOfSize:13];
	label.textColor = [UIColor darkGrayColor];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentRight;
	self.currentCityLab = label;
	[label release];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"URLDatabase" ofType:@"plist"];
	
    if (path){
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
		cityNum = [dict count];
	}
	
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.settingTableView reloadData];
 
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

- (IBAction) SendEmail:(id)sender{
	NSLog(@"--------sendEmail---");

	MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
	if(mailCompose){
		[mailCompose setMailComposeDelegate:self];
		
		NSArray *toAddress = [NSArray arrayWithObject:@"haichao.xx@163.com"];
		NSArray *ccAddress = [NSArray arrayWithObject:@"125379283@qq.com"];
		
		[mailCompose setToRecipients:toAddress];
		[mailCompose setCcRecipients:ccAddress];
		
		[mailCompose setSubject:@"City_Bus"];
//		[mailCompose addAttachmentData:pngData mimeType:@"image/png" fileName:@"floorplan.png"];
//		[mailCompose addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"1.png"];
		[self presentModalViewController:mailCompose animated:YES];
	}
	
	[mailCompose release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{	
	// Notifies users about errors associated with the interface
	switch (result){
		case MFMailComposeResultCancelled:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send e-mail Cancel"
															message:@""
														   delegate:self
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		case MFMailComposeResultSaved:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail have been saved"
															message:@""
														   delegate:self
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		case MFMailComposeResultSent:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail has been sent"
															message:@""
														   delegate:self
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		case MFMailComposeResultFailed:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail Fail to send"
															message:@""
														   delegate:self
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		default:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail Not Sent"
															message:@""
														   delegate:self
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		return @"系统设置";
	}
	else if (section == 1) {
		return @"数据设置";
	}
	else if (section == 2) {
		return @"软件信息";
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 1){
		return 2;
	}
	
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // Configure the cell...

	if (indexPath.section == 0){
		cell.textLabel.text = @"主题设置";
	}
	else if(indexPath.section == 1){
		if (indexPath.row == 0) {
			currentCityLab.text = [[NSString alloc] initWithFormat:@"当前城市:%@",[CDataContainer Instance].currentCityName];
			[cell.contentView addSubview:currentCityLab];
			cell.textLabel.text = @"当前城市";
		}
		else if(indexPath.row == 1){
			cityNumLab.text = [[NSString alloc] initWithFormat:@"城市数量:%d",cityNum];
			[cell.contentView addSubview:cityNumLab];
			cell.textLabel.text = @"数据下载";
		}
	}
	else if(indexPath.section == 2){
		cell.textLabel.text = @"软件信息";
	}
	
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
	if(indexPath.section == 0 && indexPath.row == 0){
		UIActionSheet	*actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择主题" 
																delegate:self
													   cancelButtonTitle:@"Cancle" 
												  destructiveButtonTitle:@"默认主题" 
													   otherButtonTitles:@"黑色主题",nil];
	
		actionSheet.actionSheetStyle = self.navigationController.navigationBar.barStyle;
		[actionSheet showFromTabBar:self.tabBarController.tabBar];
		
		[actionSheet release];
	}
	else if (indexPath.section == 1 && indexPath.row == 0) {
			
		CBus_CurrentCityViewController *detailViewController = [[CBus_CurrentCityViewController alloc] initWithNibName:@"CBus_CurrentCityView" bundle:nil];
		// ...
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
	else if (indexPath.section == 1 && indexPath.row == 1) {
		CBus_CityDataViewController *detailViewController = [[CBus_CityDataViewController alloc] initWithNibName:@"CBus_CityDataView" bundle:nil];
		// ...
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
	else if(indexPath.section == 2 && indexPath.row == 0){
		CBus_InfoViewController *detailViewController = [[CBus_InfoViewController alloc] initWithNibName:@"CBus_InfoView" bundle:nil];
		// ...
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSLog(@"------%d-------",buttonIndex);
	
	NSUserDefaults	*userDefault = [NSUserDefaults standardUserDefaults];
	
	switch (buttonIndex) {
		case 0:{
				[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
				self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
				[userDefault setInteger:EDefaultType forKey:@"styleType"];
				break;
			}
		case 1:{
				[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
				self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
				[userDefault setInteger:EBlackType forKey:@"styleType"];
				break;
			}
		}
	
	[userDefault synchronize];
}

/**/
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	self.settingTableView = nil;

}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[settingTableView release];
	[cityNumLab release];
	[currentCityLab release];
    [super dealloc];
}


@end
