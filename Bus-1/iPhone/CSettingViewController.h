//
//  CSettingViewController.h
//  Bus
//
//  Created by Wenter Zhu on 11-1-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>



@interface CSettingViewController : UIViewController <UITableViewDelegate,
									UITableViewDataSource, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{

	UITableView		*settingTableView;
	
	UILabel			*cityNumLab;
	UILabel			*currentCityLab;
									
	NSInteger		cityNum;
}

@property (nonatomic, retain) IBOutlet UITableView		*settingTableView;
@property (nonatomic, retain) UILabel	*cityNumLab;
@property (nonatomic, retain) UILabel   *currentCityLab;


@end
