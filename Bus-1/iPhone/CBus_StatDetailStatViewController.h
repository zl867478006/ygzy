//
//  CBus_StatDetailStatViewController.h
//  Bus
//
//  Created by Tide Zhang on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBus_StatDetailStatViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    
	UITableView		*busLineDetailTableView;
	
//当前查询的线路的index
	NSInteger		currentLineIndex;
	NSString		*currentLineName;
	
	NSMutableArray	*upLineArray;
	NSMutableArray	*downLineArray;

    BOOL			isStatToStat;
}
@property(nonatomic, retain) IBOutlet 	UITableView		*busLineDetailTableView;

@property(nonatomic, retain)	NSString		*currentLineName;

@property(nonatomic)			NSInteger		currentLineIndex;
@property(nonatomic)			BOOL			isStatToStat;


-(void)AddLineToFavorite;


@end
