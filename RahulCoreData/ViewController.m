//
//  ViewController.m
//  RahulCoreData
//
//  Created by Rahul on 11/23/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray * ShowList;
    UILabel * noRecords;
}

@end

@implementation ViewController

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ShowList = [[NSMutableArray alloc]init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FirstEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    //    NSLog(@"Fetch result : %@",fetchedObjects);
    for (NSManagedObject *info in fetchedObjects) {
//        NSLog(@"Name: %@", [info valueForKey:@"name"]);
        [ShowList addObject:[info valueForKey:@"name"]];
    }
    [self.tables reloadData];
    self.Records.text = [NSString stringWithFormat:@"Total records: %d",ShowList.count];
    self.textEnter.text =@"";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Add:(id)sender
{
    [self.textEnter resignFirstResponder];
    NSString * AddObjt = self.textEnter.text;
    if (AddObjt.length == 0) {
        NSLog(@"No data to add");
        UIAlertController * controlls = [UIAlertController alertControllerWithTitle:nil message:@"Please enter the record" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [controlls dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [controlls addAction:ok];
        [self presentViewController:controlls animated:YES completion:nil];

    }else{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *FirstEnti = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"FirstEntity"
                                  inManagedObjectContext:context];
    [FirstEnti setValue:AddObjt forKey:@"name"];
        ShowList = [[NSMutableArray alloc]init];

//    NSManagedObject *SecondEnti = [NSEntityDescription
//                                   insertNewObjectForEntityForName:@"SecondEntity"
//                                   inManagedObjectContext:context];
//    [SecondEnti setValue:@"Nashik" forKey:@"city"];
//    [SecondEnti setValue:FirstEnti forKey:@"info"];
//    [FirstEnti setValue:SecondEnti forKey:@"details"];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
    else
    {
        NSLog(@"Saved successfully");
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FirstEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    NSLog(@"Fetch result : %@",fetchedObjects);
    for (NSManagedObject *info in fetchedObjects) {
//        NSLog(@"Name: %@", [info valueForKey:@"name"]);
        [ShowList addObject:[info valueForKey:@"name"]];

    }
    [self.tables reloadData];
        self.textEnter.text =@"";
        self.Records.text = [NSString stringWithFormat:@"Total records: %d",ShowList.count];

    }
    
    noRecords = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    noRecords.center = self.tables.center;
    noRecords.text = @"No Records Found";
//    [self.tables addSubview:noRecords];

}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RahulCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RahulCoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "esds.RahulCoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self saveContext];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (ShowList.count != 0) {
        noRecords.hidden = YES;
    }
    else
    {
        noRecords.hidden = NO;
    }
    return ShowList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [ShowList objectAtIndex:indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSManagedObjectContext * context = [self managedObjectContext];
        NSString *soughtPid=[ShowList objectAtIndex:indexPath.row];
        NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"FirstEntity" inManagedObjectContext:context];
        NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
        [fetch setEntity:productEntity];
        NSPredicate *p=[NSPredicate predicateWithFormat:@"name == %@", soughtPid];
        [fetch setPredicate:p];
        //... add sorts if you want them
        NSError *fetchError;
        NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
        for (NSManagedObject *product in fetchedProducts) {
            [context deleteObject:product];
        }
        [context save:nil];
        [ShowList removeObjectAtIndex:indexPath.row];
    }
    [self.tables reloadData];
    self.Records.text = [NSString stringWithFormat:@"Total records: %d",ShowList.count];

}

@end
