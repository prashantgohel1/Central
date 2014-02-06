//
//  ISCityViewController.h
//  ViewControllerTest
//
//  Created by ispluser on 1/3/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISCityViewController : UITableViewController
- (id)initWithStyle:(UITableViewStyle)style dataObj:(NSMutableArray*)cities;
@property NSMutableArray* cities;
@property  NSMutableArray* citiesTemp;
-(IBAction)editCityView:(id)sender;
- (IBAction) addNewCity:(id) sender;
-(IBAction)cancelEditCityView:(id)sender;
@property UIButton * add;



@end
