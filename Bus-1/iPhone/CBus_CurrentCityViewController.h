//
//  CBus_CurrentCityViewController.h
//  Bus
//
//  Created by Tide Zhang on 11-4-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CBus_CurrentCityViewController : UITableViewController {

	
	NSIndexPath	*lastIndexPath;
	
	NSString	*selectCityName;
}

@property (nonatomic, retain) NSIndexPath *lastIndexPath;
@property (nonatomic, retain) NSString *selectCityName;

@end
