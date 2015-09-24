//
//  ViewController.m
//  Tutorial - Coredata
//
//  Created by Quix Creations Singapore iOS 1 on 24/9/15.
//  Copyright © 2015 Terry Chia. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *name;
@property (nonatomic,strong)NSMutableArray *phone;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.name = [[NSMutableArray alloc]init];
    self.phone = [[NSMutableArray alloc]init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name =%@)",@"Vea Software"];
    [request setPredicate:pred];
    NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        NSLog(@"No Matches");
    }else{
        for (int i = 0; i <objects.count; i++) {

            matches = objects[i];
            [self.name addObject:[matches valueForKey:@"name"]];
            [self.phone addObject:[matches valueForKey:@"phone"]];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)add:(id)sender {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
    [newContact setValue:@"Vea Software" forKey:@"name"];
    [newContact setValue:@"123-123" forKey:@"phone"];
    
    //this is for tableview
    [self.name addObject:@"Vea Software"];
    [self.phone addObject:@"123-123"];
    
    NSError *error;
    [context save:&error];
    
    //reload tableview
    [self.tableView reloadData];
}


#pragma tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.name.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [self.name objectAtIndex:indexPath.row];
    return cell;
}
@end
