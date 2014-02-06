//
//  ISMonitorViewController.h
//  Central
//
//  Created by ispluser on 1/29/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISBluetooth.h"
#import "ISAppDelegate.h"

@interface ISMonitorViewController : UIViewController <ISBluetoothDelegate>
@property (weak, nonatomic) IBOutlet UILabel *hrLbl;
@property (weak, nonatomic) IBOutlet UILabel *sensorLocationLbl;
- (IBAction)readSensorLocation:(id)sender;
- (IBAction)resetCOntrolPoint:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *char1;
@property (weak, nonatomic) IBOutlet UIView *char2;
@property (weak, nonatomic) IBOutlet UIView *char3;
@property ISBluetooth *bluetoothManager;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil HR:(BOOL)c1
           bodySensor:(BOOL)c2     CP:(BOOL)c3;
- (IBAction)showGraph:(id)sender;
- (IBAction)back:(id)sender;
@end
