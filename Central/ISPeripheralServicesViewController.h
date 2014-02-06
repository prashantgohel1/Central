//
//  ISPeripheralServicesViewController.h
//  Central
//
//  Created by ispluser on 1/29/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISBluetooth.h"
#import "ISAppDelegate.h"
@interface ISPeripheralServicesViewController : UITableViewController <ISBluetoothDelegate>
@property ISBluetooth *bluetoothManager;
@property BOOL isHearRateAvailable;
@property BOOL isBodySensorLocationAvailable;
@property BOOL isControlPointAvailable;

@end
