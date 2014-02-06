//
//  ISAppDelegate.h
//  Central
//
//  Created by ispluser on 1/28/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISBluetooth.h"

@interface ISAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property ISBluetooth *bluetoothManager;
-(ISBluetooth *)getBluetoothManager;
@end
