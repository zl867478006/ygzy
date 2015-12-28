//
//  CBus_CityDataViewController.m
//  Bus
//
//  Created by Tide Zhang on 11-3-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBus_CityDataViewController.h"
#import "CDataContainer.h"

#define BaseURL @"http://192.168.5.108/~apple/Database/"


@implementation CBus_CityDataViewController

@synthesize cityDataTableView;
@synthesize progressView;
@synthesize urlArray;
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
	
	self.navigationItem.prompt = @"选择城市名称进行数据下载:";
	
	progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	progressView.frame = CGRectMake(100, 20, 200, 10);
	progressView.progress = 0.0;

    /* create and load the URL array using the strings stored in URLCache.plist */
	
    NSString *path = [[NSBundle mainBundle] pathForResource:@"URLDatabase" ofType:@"plist"];
	
    if (path){
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
		[CDataContainer Instance].allCityArray = [NSMutableArray  arrayWithArray:[dict allKeys]];
		
		if (urlArray == nil) {
			urlArray = [[NSMutableArray alloc] init];
		}
		self.urlArray  = [NSMutableArray  arrayWithArray:[dict allValues]];    
		NSLog(@"urlArray-----%@",urlArray);
    }

}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	 self.title = @"城市信息下载";
	[[HttpRequest sharedRequest] setRequestDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];	
	[[HttpRequest sharedRequest] setRequestDelegate:nil];
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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	 return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[CDataContainer Instance].allCityArray count];
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
	
	cell.textLabel.text = [[CDataContainer Instance].allCityArray objectAtIndex:indexPath.row];
	cell.imageView.image = [UIImage imageNamed:@"bus_download.png"];
	
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
//	[self displayImageWithURL:[urlArray objectAtIndex:indexPath.row]];
	
	self.cityDataTableView.userInteractionEnabled = NO;
	downloadCityName = [NSString stringWithString:[[CDataContainer Instance].allCityArray objectAtIndex:indexPath.row]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *tempPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[urlArray objectAtIndex:indexPath.row]];
	
	
	progressView.hidden = NO;
	progressView.progress = 0.0;
	[[tableView cellForRowAtIndexPath:indexPath].contentView addSubview:progressView];

	[[HttpRequest sharedRequest] sendDownloadDatabaseRequest:[urlArray objectAtIndex:indexPath.row] desPath:tempPath];
}

// 开始发送请求,通知外部程序
- (void)connectionStart:(HttpRequest *)request
{
	NSLog(@"开始发送请求,通知外部程序");
}

// 连接错误,通知外部程序
- (void)connectionFailed:(HttpRequest *)request error:(NSError *)error
{
	NSLog(@"连接错误,通知外部程序");
	
	self.cityDataTableView.userInteractionEnabled = YES;

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:@"连接错误" 
												   delegate:self 
										  cancelButtonTitle:@"确定"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

// 开始下载，通知外部程序
- (void)connectionDownloadStart:(HttpRequest *)request
{
	NSLog(@"开始下载，通知外部程序");
}

// 下载结束，通知外部程序
- (void)connectionDownloadFinished:(HttpRequest *)request
{
	NSLog(@"下载结束，通知外部程序");
	
	self.progressView.hidden = YES;
	self.cityDataTableView.userInteractionEnabled = YES;
	NSUserDefaults	*userDefault = [NSUserDefaults standardUserDefaults];

	BOOL	isNotAlready = YES;
	
	for(NSString *name in [CDataContainer Instance].downloadCitysArray){
		if ([name isEqualToString:downloadCityName]) {
			isNotAlready = NO;
		}
	}
	
	if (isNotAlready) {
		[[CDataContainer Instance].downloadCitysArray addObject:downloadCityName];
		[userDefault setObject:[CDataContainer Instance].downloadCitysArray forKey:@"downloadCitys"];
		[userDefault synchronize];
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:@"下载完成" 
												   delegate:self 
										  cancelButtonTitle:@"确定"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];

}

// 更新下载进度，通知外部程序
- (void)connectionDownloadUpdateProcess:(HttpRequest *)request process:(CGFloat)process
{
	NSLog(@"Process = %f", process);
	progressView.progress = process;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[cityDataTableView release];
	[progressView release];
	[urlArray release];
}


@end
