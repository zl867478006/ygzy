//
//  CBus_CityDataViewController.h
//  Bus
//
//  Created by Tide Zhang on 11-3-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest.h"

@interface CBus_CityDataViewController : UIViewController <HttpRequestDelegate>{

	UITableView		*cityDataTableView;
	UIProgressView	*progressView;

	NSMutableArray	*urlArray;
	NSString		*downloadCityName;
}

@property (nonatomic, retain) IBOutlet	UITableView		*cityDataTableView;
@property (nonatomic, retain) UIProgressView	*progressView;


@property (nonatomic, retain) NSMutableArray	*urlArray;
@end
