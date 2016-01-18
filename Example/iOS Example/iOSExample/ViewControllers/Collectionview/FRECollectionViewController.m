//
//  FRECollectionViewController.m
//  iOSExample
//
//  Created by William Boles on 18/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "FRECollectionViewController.h"

#import <CoreDataServices/CDSServiceManager.h>
#import <CoreDataServices/NSManagedObjectContext+CDSRetrieval.h>
#import <CoreDataServices/NSManagedObjectContext+CDSDelete.h>
#import <CoreDataServices/NSEntityDescription+CDSEntityDescription.h>
#import <FetchedResultsController/FRCCollectionViewFetchedResultsController.h>

#import "FREUserCollectionViewCell.h"
#import "FREUser.h"

@interface FRECollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIBarButtonItem *insertUserBarButtonItem;

@property (nonatomic, strong) FRCCollectionViewFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSFetchRequest *fetchRequest;

@property (nonatomic, strong) NSArray *sortDescriptorsForFetchRequest;

- (void)insertButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation FRECollectionViewController

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*-------------------*/
    
    self.title = @"Collection";
    
    /*-------------------*/
    
    self.navigationItem.rightBarButtonItem = self.insertUserBarButtonItem;
    
    /*-------------------*/
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - Subview

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 2.0f;
        layout.minimumLineSpacing = 4.0f;
        layout.sectionInset = UIEdgeInsetsMake(4.0f,
                                               0.0f,
                                               4.0f,
                                               0.0f);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                             collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[FREUserCollectionViewCell class]
            forCellWithReuseIdentifier:[FREUserCollectionViewCell reuseIdentifier]];
    }
    
    return _collectionView;
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

- (FRCCollectionViewFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        _fetchedResultsController = [[FRCCollectionViewFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                                  managedObjectContext:[CDSServiceManager sharedInstance].managedObjectContext
                                                                                    sectionNameKeyPath:nil
                                                                                             cacheName:nil];
        
        _fetchedResultsController.collectionView = self.collectionView;
        
        [_fetchedResultsController performFetch:nil];
    }
    
    return _fetchedResultsController;
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription cds_entityForClass:[FREUser class]
                                           inManagedObjectContext:[CDSServiceManager sharedInstance].managedObjectContext];
    
    fetchRequest.sortDescriptors = self.sortDescriptorsForFetchRequest;
    
    return fetchRequest;
}

- (NSArray *)sortDescriptorsForFetchRequest
{
    NSSortDescriptor *ageSort = [NSSortDescriptor sortDescriptorWithKey:@"age"
                                                              ascending:YES];
    
    
    return @[ageSort];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FREUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FREUserCollectionViewCell reuseIdentifier]
                                                                                forIndexPath:indexPath];
    
    FREUser *user = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    cell.nameLabel.text = user.name;
    cell.ageLabel.text = [NSString stringWithFormat:@"%@", user.age];
    
    [cell layoutByApplyingConstraints];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FREUser *user = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID MATCHES %@", user.userID];
    
    [[CDSServiceManager sharedInstance].managedObjectContext cds_deleteEntriesForEntityClass:[FREUser class]
                                                                                   predicate:predicate];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150.0f,
                      150.0f);
}

#pragma mark - Insert

- (void)insertButtonPressed:(UIBarButtonItem *)sender
{
    FREUser *user = [NSEntityDescription cds_insertNewObjectForEntityForClass:[FREUser class]
                                                       inManagedObjectContext:[CDSServiceManager sharedInstance].managedObjectContext];
    
    user.userID = [NSUUID UUID].UUIDString;
    user.name = [NSString stringWithFormat:@"Collection %@", @(self.fetchedResultsController.fetchedObjects.count)];
    user.age = @(arc4random_uniform(102));
    
    [[CDSServiceManager sharedInstance].managedObjectContext save:nil];
}

@end
