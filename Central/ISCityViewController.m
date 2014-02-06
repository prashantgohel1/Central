//
//  ISCityViewController.m
//  ViewControllerTest
//
//  Created by ispluser on 1/3/14.
//  Copyright (c) 2014 ISC. All rights reserved.
//
#define TITLE_TAG 1
#define SUBTITLE_TAG 2
#define IMAGE_TAG 3



#import "ISCityViewController.h"
#import "ISCity.h"
#import "ISCityDetailViewController.h"
#import "ISAddCityViewController.h"
@interface ISCityViewController ()

@end

@implementation ISCityViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithStyle:(UITableViewStyle)style dataObj:(NSMutableArray*)cities
{
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        // _cities=cities;
        
        _citiesTemp=cities;
        
    }
    return self;
}

-(void)arrageIndexes
{
    
    
    
    self.cities=[NSMutableArray arrayWithCapacity:1];
    
    
    //changes start
    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for(ISCity *city in self.citiesTemp)
    {
        NSInteger sect = [theCollation sectionForObject:city collationStringSelector:@selector(getTitle)];
        city.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    // (3)
    for (ISCity *city in self.citiesTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:city.sectionNumber] addObject:city];
    }
    // (4)
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSMutableArray *sortedSection =[NSMutableArray arrayWithArray: [theCollation sortedArrayFromArray:sectionArray
                                                                                  collationStringSelector:@selector(getTitle)]];
        [self.cities addObject:sortedSection];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Cities";
   self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editCityView:)];
    // self.add=[[UIButton alloc]initWithFrame:CGRectMake(5, 5,self.add.superview.frame.size.width-10, self.add.superview.frame.size.height-10)];
    
    
    //[self.add.superview addConstraint:nsl];
    self.add=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 300, 30) ];
    
    //[self.add.superview addConstraint:nsl];
    
    
    
    self.add.backgroundColor=[UIColor greenColor];
    [self.add setTitle:@"Add New" forState:UIControlStateNormal];
    [self.add addTarget:self action:@selector(addNewCity:) forControlEvents:UIControlEventTouchUpInside];
   self.add.enabled=NO;
    [self.add setHidden:YES];
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    
    UIBarButtonItem* add1=[[UIBarButtonItem alloc]initWithCustomView:self.add ];
   // self.add1=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonSystemItemAdd target:self action:@selector(addNewCity:)];
    
    
    
    [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, add1,flexibleSpace,nil] ];
  //  NSLog(@"%@",self.navigationController.toolbarItems);
    
    // [[self navigationController] setNavigationBarHidden:YES animated:YES];
    // [self.cities addObject:@""];
    
    // [self arrageIndexes];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    // NSLog(@"%@",[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]);
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    
    /* if (section==[self.cities count]) {
     //  NSLog(@"here at add:%i",section);
     return nil;
     }*/
    
    if ([[self.cities objectAtIndex:section] count] > 0) {
        
       // NSLog(@"%@",[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section]);
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

-(IBAction)editCityView:(id)sender
{
    [self.tableView setEditing:YES animated:YES];
    [self.add setHidden:NO];
    self.navigationController.toolbarHidden=NO;
    self.add.enabled=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEditCityView:)];
    self.navigationItem.rightBarButtonItem=nil;
    
}
-(IBAction)cancelEditCityView:(id)sender
{
    [self.tableView setEditing:NO animated:YES];
    self.add.enabled=NO;
    [self.add setHidden:YES];
    self.navigationController.toolbarHidden=YES;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editCityView:)];
    self.navigationItem.leftBarButtonItem=nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self arrageIndexes];
    [self.tableView reloadData];
    
    
    //NSLog(@"View did Appear");
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.cities count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    /* if(section==[self.cities count])
     {
     return 1;
     }*/
    
    return [[self.cities objectAtIndex:section]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UILabel *mainLabel, *secondLabel;
    UIImageView *photo;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 5.0, 150.0, 15.0)];
        mainLabel.tag = TITLE_TAG;
        //  [mainLabel addConstraint:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-" options:<#(NSLayoutFormatOptions)#> metrics:<#(NSDictionary *)#> views:<#(NSDictionary *)#>]]
        mainLabel.font = [UIFont systemFontOfSize:14.0 ];
        
        mainLabel.textColor = [UIColor blackColor];
        // mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:mainLabel];
        //mainLabel.backgroundColor=[UIColor redColor];
        
        secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 20.0, 150.0, 25.0)];
        secondLabel.tag = SUBTITLE_TAG;
        secondLabel.font = [UIFont systemFontOfSize:12.0];
        secondLabel.textColor = [UIColor darkGrayColor];
        // secondLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:secondLabel];
        
        photo = [[UIImageView alloc] init];
        photo.tag = IMAGE_TAG;
        // photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
        photo.frame=CGRectMake(180.0, 6, 32.0, 32.0);
    } else {
        mainLabel = (UILabel *)[cell.contentView viewWithTag:TITLE_TAG];
        secondLabel = (UILabel *)[cell.contentView viewWithTag:SUBTITLE_TAG];
        photo = (UIImageView *)[cell.contentView viewWithTag:IMAGE_TAG];
    }
    // photo.backgroundColor=[UIColor yellowColor];
    // NSLog(@"%i",indexPath.row);
    mainLabel.text = [(ISCity *)[[self.cities objectAtIndex:indexPath.section] objectAtIndex:indexPath.row
                                 ] title];
    secondLabel.text = [(ISCity *)[[self.cities objectAtIndex:indexPath.section]objectAtIndex:indexPath.row
                                   ] subtitle];
    [[[self.cities objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] setImagePath];
    NSString *path=[(ISCity *)[[self.cities objectAtIndex:indexPath.section]objectAtIndex:indexPath.row
                               ] imgPath];
    
    if(path!=nil)
    {
        //[photo setBackgroundColor:[UIColor greenColor]];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
        UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
        photo.image = theImage;
        
    }
    
    return cell;
    
}
-(IBAction)addNewCity:(id)sender
{
    [self presentViewController:[[ISAddCityViewController alloc]initWithNibName:nil bundle:nil dataObj:self.citiesTemp] animated:YES completion:nil];
    
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        BOOL emptySection=NO;
        if([[self.cities objectAtIndex:indexPath.section] count]==1)
        {
            emptySection=YES;
        }
        
        [self.citiesTemp removeObject:[[self.cities objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        // NSLog(@"%i,%i",indexPath.section,indexPath.row);
        [[self.cities objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        //[self arrageIndexes];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        if(emptySection==YES)
        {
            //NSLog(@"%@",tableView.sc);
            [tableView setContentOffset:CGPointMake(tableView.contentOffset.x
                                                    , tableView.contentOffset.y-1
                                                    ) animated:NO];
            [tableView setContentOffset:CGPointMake(tableView.contentOffset.x
                                                    , tableView.contentOffset.y+1
                                                    ) animated:NO];
            
        }
        
        
        // [self arrageIndexes];
        //
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Navigation logic may go here, for example:
    // Create the next view controller.
    // <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    NSMutableDictionary *dataToPass=[(ISCity *)[[self.cities objectAtIndex:indexPath.section]objectAtIndex:indexPath.row ]cityDetail];
    if(dataToPass==nil)
    {
        [(ISCity *)[[self.cities objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] setCityDetail1:[NSMutableDictionary dictionaryWithCapacity:1]];
        dataToPass=[(ISCity *)[[self.cities objectAtIndex:indexPath.section]objectAtIndex:indexPath.row ]cityDetail];
    }
    
    ISCityDetailViewController *cityDetailViewController=[[ISCityDetailViewController alloc]initWithStyle:UITableViewStylePlain dataObj:dataToPass];
    // Pass the selected object to the new view controller.
    //  self.navigationItem.backBarButtonItem.title=[[self.cities objectAtIndex:indexPath.row]title];
    
    // Push the view controller.
    [self.navigationController pushViewController:cityDetailViewController animated:YES];
    
    
}



@end
