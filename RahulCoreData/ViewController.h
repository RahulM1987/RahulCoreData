//
//  ViewController.h
//  RahulCoreData
//
//  Created by Rahul on 11/23/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface ViewController : UIViewController


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// View connections

@property (weak, nonatomic) IBOutlet UITextField *textEnter;
@property (weak, nonatomic) IBOutlet UIButton *Add;
@property (weak, nonatomic) IBOutlet UITableView *tables;
@property (weak, nonatomic) IBOutlet UILabel *Records;

@end

