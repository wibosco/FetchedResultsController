//
//  FRETableViewController.m
//  iOSExample
//
//  Created by William Boles on 15/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "FRETableViewController.h"

#import <CoreDataServices/CDSServiceManager.h>
#import <CoreDataServices/NSManagedObjectContext+CDSRetrieval.h>
#import <CoreDataServices/NSManagedObjectContext+CDSDelete.h>
#import <CoreDataServices/NSManagedObjectContext+CDSCount.h>
#import <CoreDataServices/NSEntityDescription+CDSEntityDescription.h>
#import <PureLayout/PureLayout.h>

#import "FREUser.h"
#import "FREUserTableViewCell.h"

@interface FRETableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *users;

@property (nonatomic, strong) UIBarButtonItem *insertUserBarButtonItem;

- (void)insertButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation FRETableViewController

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*-------------------*/
    
    self.title = @"Users";
    
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

- (NSArray *)users
{
    if (!_users)
    {
        NSSortDescriptor *ageSort = [NSSortDescriptor sortDescriptorWithKey:@"age"
                                                                  ascending:YES];
        
        _users = [[CDSServiceManager sharedInstance].managedObjectContext cds_retrieveEntriesForEntityClass:[FREUser class]
                                                                                            sortDescriptors:@[ageSort]];
    }
    
    return _users;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FREUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FREUserTableViewCell reuseIdentifier]
                                                                 forIndexPath:indexPath];
    
    FREUser *user = self.users[indexPath.row];
    
    cell.nameLabel.text = user.name;
    cell.ageLabel.text = [NSString stringWithFormat:@"%@", user.age];
    
    [cell layoutByApplyingConstraints];
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Total Users: %@", @([[CDSServiceManager sharedInstance].managedObjectContext cds_retrieveEntriesCountForEntityClass:[FREUser class]])];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FREUser *user = self.users[indexPath.row];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID MATCHES %@", user.userID]; //I could have passed the user itself but I wanted to demostrate a predicate being used
    
    [[CDSServiceManager sharedInstance].managedObjectContext cds_deleteEntriesForEntityClass:[FREUser class]
                                                                                   predicate:predicate];
    
    self.users = nil;
    
    [self.tableView reloadData];
}

#pragma mark - Insert

- (void)insertButtonPressed:(UIBarButtonItem *)sender
{
    FREUser *user = [NSEntityDescription cds_insertNewObjectForEntityForClass:[FREUser class]
                                                       inManagedObjectContext:[CDSServiceManager sharedInstance].managedObjectContext];
    
    user.userID = [NSUUID UUID].UUIDString;
    user.name = [NSString stringWithFormat:@"Example %@", @(self.users.count)];
    user.age = @(arc4random_uniform(102));
    
    self.users = nil;
    
    [self.tableView reloadData];
}

@end
