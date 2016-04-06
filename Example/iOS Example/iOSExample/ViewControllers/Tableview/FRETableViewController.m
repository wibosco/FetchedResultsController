//
//  FRETableViewController.m
//  iOSExample
//
//  Created by William Boles on 15/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "FRETableViewController.h"

#import <FetchedResultsController/FetchedResultsController-Swift.h>
#import <CoreDataServices/CoreDataServices-Swift.h>

#import "FREUser.h"
#import "FREUserTableViewCell.h"

@interface FRETableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *insertUserBarButtonItem;

@property (nonatomic, strong) FRCTableViewFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSFetchRequest *fetchRequest;

@property (nonatomic, strong) NSArray *sortDescriptorsForFetchRequest;

- (void)insertButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation FRETableViewController

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*-------------------*/
    
    self.title = @"Table";
    
    /*-------------------*/
    
    self.navigationItem.rightBarButtonItem = self.insertUserBarButtonItem;
    
    /*-------------------*/
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Subview

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                  style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[FREUserTableViewCell class]
           forCellReuseIdentifier:[FREUserTableViewCell reuseIdentifier]];
    }
    
    return _tableView;
}

- (UIBarButtonItem *)insertUserBarButtonItem
{
    if (!_insertUserBarButtonItem)
    {
        _insertUserBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(insertButtonPressed:)];
    }
    
    return _insertUserBarButtonItem;
}

#pragma mark - Users

- (FRCTableViewFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        _fetchedResultsController = [[FRCTableViewFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                                  managedObjectContext:[ServiceManager sharedInstance].mainManagedObjectContext
                                                                                    sectionNameKeyPath:nil
                                                                                             cacheName:nil];
        
        _fetchedResultsController.tableView = self.tableView;
        
        [_fetchedResultsController performFetch:nil];
    }
    
    return _fetchedResultsController;
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription cds_entityForClass:[FREUser class]
                                           inManagedObjectContext:[ServiceManager sharedInstance].mainManagedObjectContext];
    
    fetchRequest.sortDescriptors = self.sortDescriptorsForFetchRequest;
    
    return fetchRequest;
}

- (NSArray *)sortDescriptorsForFetchRequest
{
    NSSortDescriptor *ageSort = [NSSortDescriptor sortDescriptorWithKey:@"age"
                                                              ascending:YES];
    
    
    return @[ageSort];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FREUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FREUserTableViewCell reuseIdentifier]
                                                                 forIndexPath:indexPath];
    
    FREUser *user = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    cell.nameLabel.text = user.name;
    cell.ageLabel.text = [NSString stringWithFormat:@"%@", user.age];
    
    [cell layoutByApplyingConstraints];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FREUser *user = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID MATCHES %@", user.userID];
    
    [[ServiceManager sharedInstance].mainManagedObjectContext cds_deleteEntriesForEntityClass:[FREUser class]
                                                                                    predicate:predicate];
}

#pragma mark - Insert

- (void)insertButtonPressed:(UIBarButtonItem *)sender
{
    FREUser *user = (FREUser *)[NSEntityDescription cds_insertNewObjectForEntityForClass:[FREUser class]
                                                                  inManagedObjectContext:[ServiceManager sharedInstance].mainManagedObjectContext];
    
    user.userID = [NSUUID UUID].UUIDString;
    user.name = [NSString stringWithFormat:@"Table %@", @(self.fetchedResultsController.fetchedObjects.count)];
    user.age = @(arc4random_uniform(102));
    
    [[ServiceManager sharedInstance] saveMainManagedObjectContext];
}

@end
