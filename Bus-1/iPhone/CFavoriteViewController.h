//
//  CFavoriteViewController.h
//  Bus
//
//  Created by Wenter Zhu on 11-1-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum ESegCtrlIndex 
{
	EFavorite_Line,
	EFavorite_Stat,
	EFavorite_StatToStat
}segCtrlIndex;

@interface CFavoriteViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{

	UITableView			*favoriteTableView;
	
	UINavigationBar		*favNavigationBar;
	UISegmentedControl	*favoriteSegCtrl;
	
	NSInteger			ESegType;
}
@property (nonatomic, retain) IBOutlet	UITableView			*favoriteTableView;
@property (nonatomic, retain) IBOutlet 	UISegmentedControl	*favoriteSegCtrl;
@property (nonatomic, retain) IBOutlet  UINavigationBar		*favNavigationBar;

-(IBAction)OnSegmentIndexChanged:(id)sender;
@end
