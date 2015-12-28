//
//  CBus_LineViewController.h
//  Bus
//
//  Created by Wenter Zhu on 11-1-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CBus_LineViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate, UISearchBarDelegate>{

	UITableView		*busLineTableView;
	NSMutableArray	*filteredListContent;

}

@property(nonatomic, retain) IBOutlet UITableView	 *busLineTableView;
@property(nonatomic, retain)		  NSMutableArray *filteredListContent;

@end
