//
//  SJViewController.m
//  TableTestView1
//
//  Created by DX141-XL on 2014-04-28.
//  Copyright (c) 2014 xtremer. All rights reserved.
//

#import "SJViewController.h"
#import <CoreData/CoreData.h>

@interface SJViewController ()

@end

@implementation SJViewController{
    //NSMutableArray *tableData;

}

-(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=4vfsqwf87nwsd2vyvzzjfjxb"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             //tableData = [[NSMutableArray alloc] init];
             NSArray* movies = [greeting objectForKey:@"movies"];
             NSManagedObjectContext *context = [self managedObjectContext];
             
           
             
             for (int i = 0; i < movies.count;i++) {
                //[tableData addObject:[movies objectAtIndex:i]];
                 NSManagedObject *newMovie = [NSEntityDescription insertNewObjectForEntityForName:@"Movies" inManagedObjectContext:context];
                 [newMovie setValue:[[movies objectAtIndex:i] objectForKey:@"title"] forKey:@"title"];
                 [newMovie setValue:[[[movies objectAtIndex:i] objectForKey:@"posters"] objectForKey:@"profile"] forKey:@"imageURL"];
              }

             [self.table1 reloadData];
             NSLog(@"hi");
            
             
         }
     }];
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Movies"];
    //NSLog(@"%lu",(unsigned long)[[[context executeFetchRequest:fetchRequest error:nil] mutableCopy] count]);
    NSManagedObjectContext *context = [self managedObjectContext];
    NSMutableArray *tableData = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];

    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Movies"];
    //NSLog(@"%lu",(unsigned long)[[[context executeFetchRequest:fetchRequest error:nil] mutableCopy] count]);
    NSManagedObjectContext *context = [self managedObjectContext];
    NSMutableArray *tableData = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    //NSLog([[tableData objectAtIndex:0] objectForKey:@"imageURL"]);
    
    UIImage* myImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: [[tableData objectAtIndex:indexPath.row] valueForKey:@"imageURL"]]]];

    cell.textLabel.text = [[tableData objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.imageView.image = myImage;
    

    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath{
    NSLog(@"hi %ld", (long)indexPath.row);
}

@end
