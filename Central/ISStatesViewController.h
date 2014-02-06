//
//  ISStatesViewController.h
//  ViewControllerTest
//
//  Created by ispluser on 1/3/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISStatesViewController : UITableViewController
- (id)initWithStyle:(UITableViewStyle)style dataObj:(NSMutableArray*)states;
@property NSMutableArray* states;
@property UIBarButtonItem *reorderButton;
@property BOOL isEditing;
@end
