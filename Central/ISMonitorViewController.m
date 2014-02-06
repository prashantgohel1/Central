//
//  ISMonitorViewController.m
//  Central
//
//  Created by ispluser on 1/29/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISMonitorViewController.h"
#import "ViewController.h"


@interface ISMonitorViewController ()

@end

@implementation ISMonitorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [_char1 setHidden:YES];
        [_char2 setHidden:YES];
        [_char3 setHidden:YES];

    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil HR:(BOOL)c1
bodySensor:(BOOL)c2     CP:(BOOL)c3
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [_char1 setHidden:!c1];
        [_char2 setHidden:!c2];
        [_char3 setHidden:!c3];
        
    }
    return self;
}

- (IBAction)showGraph:(id)sender {
    
    [self.navigationController pushViewController:[[ViewController alloc]init] animated:YES];
}


-(void)didRecieveValueForDeviceLocation:(NSString*)location
{
    self.sensorLocationLbl.text=location;
}
-(void)didResetControlPoint
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.bluetoothManager setDelegate:self];
}
+(ISAppDelegate*)appDelegate
{
    return [[UIApplication sharedApplication]delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bluetoothManager=[[ISMonitorViewController appDelegate]getBluetoothManager];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didUpdateHeartRate:(UInt16)hr formate16bit:(BOOL)is16bit
{
    self.hrLbl.text=[NSString stringWithFormat:@"%d",hr];
}

- (IBAction)readSensorLocation:(id)sender {
    [self.bluetoothManager readBodyLocationCharacteristics];
}

- (IBAction)resetCOntrolPoint:(id)sender {
    [self.bluetoothManager resetHartRateControlPoint];
}
@end
