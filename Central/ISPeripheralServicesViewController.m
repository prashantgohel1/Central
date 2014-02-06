//
//  ISPeripheralServicesViewController.m
//  Central
//
//  Created by ispluser on 1/29/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISPeripheralServicesViewController.h"
#import "ISMonitorViewController.h"
#define HEART_RATE_SERVICE_UUID @"180D"
#define HEART_RATE_MEASUREMENT_CHAR_UUID @"2A37"
#define HEART_RATE_BODY_SENSOR_LOCATION_CHAR_UUID @"2A38"
#define HEART_RATE_CONTROL_POINT_CHAR_UUID @"2A39"

@interface ISPeripheralServicesViewController ()

@end

@implementation ISPeripheralServicesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _bluetoothManager=[[ISPeripheralServicesViewController appDelegate]getBluetoothManager];
        _isBodySensorLocationAvailable=NO;
        _isControlPointAvailable=NO;
        _isHearRateAvailable=NO;
        
    }
    return self;
}
+(ISAppDelegate*)appDelegate
{
    return [[UIApplication sharedApplication]delegate];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.bluetoothManager setDelegate:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"Services";
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithTitle:@"Monitor" style:UIBarButtonItemStylePlain target:self action:@selector(monitorDevice:)];
    self.navigationItem.rightBarButtonItem = btn;
    
    
    
   // [self.navigationController setToolbarHidden:NO];
    //[self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, add1,flexibleSpace,nil] ];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(IBAction)monitorDevice:(id)sender
{
    [self presentViewController:[[ISMonitorViewController alloc]initWithNibName:nil bundle:nil HR:self.isHearRateAvailable bodySensor:self.isBodySensorLocationAvailable CP:self.isControlPointAvailable] animated:YES completion:nil];
}

-(void)didDiscoverCharacteristicsForService:(CBService *)service
{
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.bluetoothManager.connectedDeviceServices count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    NSMutableArray *temp=[self.bluetoothManager.connectedDeviceCharacteristicsForService objectForKey:[NSString stringWithFormat:@"%@",[(CBService*)[self.bluetoothManager.connectedDeviceServices objectAtIndex:section] UUID]]];
    return [temp count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CBUUID *u=[(CBService*) [self.bluetoothManager.connectedDeviceServices objectAtIndex:section]  UUID];
    NSString *s=[NSString stringWithFormat:@"%@",u];
    CBUUID *u1=[CBUUID UUIDWithString:HEART_RATE_SERVICE_UUID];
    if ([u isEqual:u1] ) {
        return @"Heart Rate Service";
    }
    return s ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"Cell";
    
    CBService *s=[self.bluetoothManager.connectedDeviceServices objectAtIndex:indexPath.section];
    NSMutableArray *temp=[self.bluetoothManager.connectedDeviceCharacteristicsForService objectForKey:[NSString stringWithFormat:@"%@",s.UUID]];
    CBCharacteristic *chara=(CBCharacteristic*)[ temp  objectAtIndex:indexPath.row];
    CBUUID *u=[chara UUID];
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1];
        cell.detailTextLabel.text=@"";
        
    }
    
    //NSLog(@"%d %d",chara.properties,CBCharacteristicPropertyNotify);
    NSString *s1=[NSString stringWithFormat:@"%@",u];
    NSString *text=[NSString stringWithString:s1];
    if ((chara.properties & (CBCharacteristicPropertyNotify))) {
        
        cell.detailTextLabel.text=@"Notifying";
        self.isHearRateAvailable=YES;
        text=[self.bluetoothManager heartRateMeasureCharDescriptor];
    }
    else if((chara.properties == CBCharacteristicPropertyRead) )
    {
       cell.detailTextLabel.text=@"Readable";
        self.isBodySensorLocationAvailable=YES;
        text=[self.bluetoothManager bodySensorLocationCharDescriptor];
    }
    else if((chara.properties & CBCharacteristicPropertyWrite) )
    {
        cell.detailTextLabel.text=@"Writable";
        self.isControlPointAvailable=YES;
        text=[self.bluetoothManager controlPointCharDescriptor];
        
    }
    
    
   cell.textLabel.text=text;
    
    
    
//    CBUUID *u1=[CBUUID UUIDWithString:HEART_RATE_MEASUREMENT_CHAR_UUID];
//    CBUUID *u2=[CBUUID UUIDWithString:HEART_RATE_BODY_SENSOR_LOCATION_CHAR_UUID];
//    CBUUID *u3=[CBUUID UUIDWithString:HEART_RATE_CONTROL_POINT_CHAR_UUID];
//
//    if ([u isEqual:u1] ) {
//        text= @"HR Measurement";
//    }
//    else if([u isEqual:u2] )
//    {
//        text=@"Body Sensor";
//    }
//    else if([u isEqual:u3] )
//    {
//        text=@"Control Point";
//    }
    
    
    
    
    
   // NSLog(@"%@",[[(CBCharacteristic*)[ temp  objectAtIndex:indexPath.row] descriptors] objectAtIndex:0]);
    
    
    // Configure the cell...
    
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

-(void)didRecieveValueForDescriptorForCharacteristics:(CBCharacteristic *)chara
{
    [self.tableView reloadData];
}
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
//    CBService *s=[self.bluetoothManager.connectedDeviceServices objectAtIndex:indexPath.section];
//    NSMutableArray *temp=[self.bluetoothManager.connectedDeviceCharacteristicsForService objectForKey:[NSString stringWithFormat:@"%@",s.UUID]];
//    CBCharacteristic *chara=(CBCharacteristic*)[ temp  objectAtIndex:indexPath.row];
    
    
//    
//    
//    if (chara.properties & (CBCharacteristicPropertyNotify)) {
//        
//        
//        [notify addTarget:self action:@selector(notificationStateChanged:) forControlEvents:UIControlEventTouchUpInside];
//        notify.enabled=YES;
//        [notify setHidden:NO];
//        
//        UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        
//        
//        UIBarButtonItem* add1=[[UIBarButtonItem alloc]initWithCustomView:notify ];
//        // self.add1=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonSystemItemAdd target:self action:@selector(addNewCity:)];
//        
//        
//        [self.navigationController setToolbarHidden:NO];
//        [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, add1,flexibleSpace,nil] ];
//    }
//    else
//    {
//         [self.navigationController setToolbarHidden:YES];
//    }
//    else if(chara.properties & CBCharacteristicPropertyRead )
//    {
//        UIButton *read=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 300, 30) ];
//        read.backgroundColor=[UIColor greenColor];
//        [read setTitle:@"Read Value" forState:UIControlStateNormal];
//        [read addTarget:self action:@selector(readChar:) forControlEvents:UIControlEventTouchUpInside];
//        read.enabled=YES;
//        [read setHidden:NO];
//        
//        UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        
//        
//        UIBarButtonItem* add1=[[UIBarButtonItem alloc]initWithCustomView:read ];
//        // self.add1=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonSystemItemAdd target:self action:@selector(addNewCity:)];
//        
//        
//        [self.navigationController setToolbarHidden:NO];
//        [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, add1,flexibleSpace,nil] ];
//    }
//    else if(chara.properties & CBCharacteristicPropertyWrite )
//    {
//        UIButton *reset=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 300, 30) ];
//        reset.backgroundColor=[UIColor greenColor];
//        [reset setTitle:@"Reset Control Point" forState:UIControlStateNormal];
//        [reset addTarget:self action:@selector(resetControlPoint:) forControlEvents:UIControlEventTouchUpInside];
//        reset.enabled=YES;
//        [reset setHidden:NO];
//        
//        UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        
//        
//        UIBarButtonItem* add1=[[UIBarButtonItem alloc]initWithCustomView:reset ];
//        // self.add1=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonSystemItemAdd target:self action:@selector(addNewCity:)];
//        
//        
//        [self.navigationController setToolbarHidden:NO];
//        [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, add1,flexibleSpace,nil] ];
//        
//    }
    

    
   
}

//-(void)notificationStateChanged:(id)sender
//{
//    
//    UIButton *b=(UIButton*)sender;
// 
//        NSIndexPath *indexPath= self.tableView.indexPathForSelectedRow;
//        CBService *s=[self.bluetoothManager.connectedDeviceServices objectAtIndex:indexPath.section];
//        NSMutableArray *temp=[self.bluetoothManager.connectedDeviceCharacteristicsForService objectForKey:[NSString stringWithFormat:@"%@",s.UUID]];
//        CBCharacteristic *chara=(CBCharacteristic*)[ temp  objectAtIndex:indexPath.row];
//    if([self.bluetoothManager.subscribedCharacteristics containsObject:chara])
//    {
//        [self.bluetoothManager subscribe:NO Characteristic:chara];
//        [b setTitle:@"Subscribe" forState:UIControlStateNormal];
//        
//    }
//    else
//    {
//        [self.bluetoothManager subscribe:YES Characteristic:chara];
//        [b setTitle:@"Unsubscribe" forState:UIControlStateNormal];
//        
//    }
//    
//}
































@end
