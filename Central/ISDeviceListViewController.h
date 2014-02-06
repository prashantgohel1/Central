//
//  ISDeviceListViewController.h
//  Central
//
//  Created by ispluser on 1/28/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ISAppDelegate.h"
#import "ISBluetooth.h"

@interface ISDeviceListViewController : UITableViewController <ISBluetoothDelegate>

@property ISBluetooth *bluetoothManager;
@property UIButton *scan;

@end
