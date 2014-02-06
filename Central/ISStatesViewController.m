//
//  ISStatesViewController.m
//  ViewControllerTest
//
//  Created by ispluser on 1/3/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//

#import "ISStatesViewController.h"
#import "ISState.h"
#import "ISCityViewController.h"
#import "ISImageWithMapCenter.h"
#import "ISMapViewController.h"
@interface ISStatesViewController ()

@end

@implementation ISStatesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithStyle:(UITableViewStyle)style dataObj:(NSMutableArray*)states
{
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _states=states;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"States";
    self.isEditing=NO;
    self.reorderButton=[[UIBarButtonItem alloc]initWithTitle:@"Reorder" style:UIBarButtonItemStylePlain target:self action:@selector(doReorder:)];
    self.navigationItem.rightBarButtonItem = self.reorderButton;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(IBAction)doReorder:(id)sender
{
    if(self.isEditing==NO)
    {
        [self.tableView setEditing:YES animated:YES];
        [self.reorderButton setTitle:@"Done"];
        
    }
    else
    {
        
            [self.tableView setEditing:NO animated:YES];
        [self.reorderButton setTitle:@"Reorder"];
    }
    self.isEditing=!self.isEditing;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.states count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myResusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    
    cell.textLabel.text=[(ISState *)[self.states objectAtIndex:indexPath.row] title];
    cell.detailTextLabel.text =[(ISState *)[self.states objectAtIndex:indexPath.row] subtitle];
    [[self.states objectAtIndex:indexPath.row]setImagePath];
    NSString *imagePath=[(ISState *)[self.states objectAtIndex:indexPath.row] imgPath];
    
    
  
    
    
    //[cell.imageView setHidden:NO];
    if(imagePath!=nil)
    {
        //set image here
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        
        singleTap.numberOfTapsRequired = 1;
        
        NSString *imagePath1 = [[NSBundle mainBundle] pathForResource:imagePath ofType:@"png"];
        ISImageWithMapCenter *theImage = [[ISImageWithMapCenter alloc] initWithContentsOfFile:imagePath1 centerPoint:[(ISState*)[self.states objectAtIndex:indexPath.row] mapCenter] zoomingScale: [(ISState*)[self.states objectAtIndex:indexPath.row] mapZooming]];
       
        cell.imageView.userInteractionEnabled = YES;
        [cell.imageView addGestureRecognizer:singleTap];
      
        [cell.imageView setImage:theImage];
       // NSLog(@"size: %f %f",theImage.size.width,theImage.size.height);
        
    }
    
    // Configure the cell...
    
    return cell;
}
-(void)tapDetected :(id)sender
{
   
    UITapGestureRecognizer * rec=(UITapGestureRecognizer*)sender;
    UIImageView *temp=(UIImageView*)rec.view;
  //  NSLog(@"%@",temp.view);
    ISImageWithMapCenter *img= (ISImageWithMapCenter *) temp.image;
    
    ISMapViewController*map= [self.tabBarController.viewControllers objectAtIndex:3];
    
    [map doZoomWithCenter:img.zoomingCenterForMap zoomingScale:img.zoomingScale];
    
    [self.tabBarController setSelectedIndex:3];
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
            return UITableViewCellEditingStyleNone;
    
}

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


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    ISState *temp=[self.states objectAtIndex:fromIndexPath.row];
    [self.states removeObjectAtIndex:fromIndexPath.row];
    [self.states insertObject:temp atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



//#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    
    ISCityViewController *cityViewController=[[ISCityViewController alloc]initWithStyle:UITableViewStylePlain dataObj:[[self.states objectAtIndex:indexPath.row] cities]];
    // Pass the selected object to the new view controller.
    self.navigationItem.backBarButtonItem.title=[[self.states objectAtIndex:indexPath.row]title];
    
    // Push the view controller.
    [self.navigationController pushViewController:cityViewController animated:YES];
}
 


@end
