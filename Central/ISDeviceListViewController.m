//
//  ISDeviceListViewController.m
//  Central
//
//  Created by ispluser on 1/28/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISDeviceListViewController.h"
#import "ISPeripheralServicesViewController.h"
#import "ISMonitorViewController.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
@interface ISDeviceListViewController ()

@end

@implementation ISDeviceListViewController
{
    UIActivityIndicatorView *processing;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(void)disconnect
{
    [self.bluetoothManager disconnectPeripheral];
    
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"Devices";
    
    
    processing=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [processing setHidesWhenStopped:YES];
   
    UIBarButtonItem *btn =[[UIBarButtonItem alloc]initWithCustomView:processing];
    [self.navigationItem setLeftBarButtonItem:btn];
    
    self.bluetoothManager=[[ISDeviceListViewController appDelegate]getBluetoothManager];
    [self.bluetoothManager setDelegate:self];
    self.scan=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 300, 30) ];
    
    
    UIBarButtonItem* add12=[[UIBarButtonItem alloc]initWithTitle:@"Disconnect" style:UIBarButtonItemStyleBordered target:self action:@selector(disconnect)];
    // self.add1=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonSystemItemAdd target:self action:@selector(addNewCity:)];
    
    [self.navigationItem setRightBarButtonItem:add12];
    
    
    
    self.scan.backgroundColor=[UIColor greenColor];
    [self.scan setTitle:@"Scan" forState:UIControlStateNormal];
    [self.scan addTarget:self action:@selector(scanForDevices) forControlEvents:UIControlEventTouchUpInside];
    self.scan.enabled=YES;
    [self.scan setHidden:NO];
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* add1=[[UIBarButtonItem alloc]initWithCustomView:self.scan ];
    // self.add1=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonSystemItemAdd target:self action:@selector(addNewCity:)];
    
    
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, add1,flexibleSpace,nil] ];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self.bluetoothManager setDelegate:self];
}
-(void)scanForDevices
{
    [self.bluetoothManager scanForDevicesWithHeartRateService];
   // [self.bluetoothManager scanForDevicesWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    [ processing startAnimating];
   
}
-(void)didStopScanning
{
    if(self.bluetoothManager.isScanning==YES)
    {
        [self.scan setUserInteractionEnabled:NO];
        [ processing startAnimating];
    }
    else
    {
        [self.scan setUserInteractionEnabled:YES];
        [ processing stopAnimating];
    }
}

+(ISAppDelegate*)appDelegate
{
    return [[UIApplication sharedApplication]delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.bluetoothManager.peripherals count];
}

-(void)didConnectPeripheral
{
    
    //[self.navigationController pushViewController:[[ISPeripheralServicesViewController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
   //  [self presentViewController:[[ISMonitorViewController alloc]initWithNibName:nil bundle:nil HR:YES  bodySensor:YES CP:NO] animated:YES completion:nil];
    [self.navigationController pushViewController:[[ISMonitorViewController alloc]initWithNibName:nil bundle:nil HR:YES  bodySensor:YES CP:NO] animated:YES];
    
    
}
-(void)didDiscoverPeripheral:(CBPeripheral *)peripheral
{
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myResusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    CBPeripheral *p=(CBPeripheral*)[self.bluetoothManager.peripherals objectAtIndex:indexPath.row];
    
    cell.textLabel.text=p.name;
    
    

    NSUUID *u1,*u2;
    BOOL isSame=NO;
    if (SYSTEM_VERSION_EQUAL_TO(@"7.0")) {
        
        u1=self.bluetoothManager.connectedPeripheral.identifier;
        u2=p.identifier;
        
        if ([u1 isEqual:u2]) {
            isSame=YES;
        }
        
    }
    else
    {
        isSame=[p isConnected];
    }
    
    if(isSame)
    {
        cell.detailTextLabel.text=@"Connected";
    }
    else
    {
        cell.detailTextLabel.text=nil;
    }
    
    
       
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


//#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *p=(CBPeripheral*)[self.bluetoothManager.peripherals objectAtIndex:indexPath.row];

    
    NSUUID *u1,*u2;
    BOOL isSame=NO;
    if (SYSTEM_VERSION_EQUAL_TO(@"7.0")) {
        
        u1=self.bluetoothManager.connectedPeripheral.identifier;
        u2=p.identifier;
        
        if ([u1 isEqual:u2]) {
            isSame=YES;
        }
        
    }
    else
    {
        isSame=[p isConnected];
    }
    
    if(!isSame)
    {
        [self.bluetoothManager connectPeripheral:[self.bluetoothManager.peripherals objectAtIndex:indexPath.row  ]options:nil];
    }
    else
    {
       [self.navigationController pushViewController:[[ISPeripheralServicesViewController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
    }

    
    
    
    
  
    
}
 


@end
