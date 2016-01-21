//
//  CDSCollectionViewFetchedResultsController.m
//  FetchedResultsController
//
//  Created by William Boles on 21/05/2015.
//  Copyright (c) 2014 Boles. All rights reserved.
//

#import "FRCCollectionViewFetchedResultsController.h"

@interface FRCCollectionViewFetchedResultsController ()

@property (nonatomic, strong) NSDictionary *objectChanges;
@property (nonatomic, strong) NSDictionary *sectionChanges;
@property (nonatomic, strong) NSMutableIndexSet *excludedSections;

/**
 Normalizes the index path.
 
 @param indexPath - indexPath to normalize.
 
 @return NSIndexPath.
 */
- (NSIndexPath *)normalizeIndexPath:(NSIndexPath *)indexPath;

@end

@implementation FRCCollectionViewFetchedResultsController

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.delegate = self;
    }
    
    return self;
}

- (instancetype)initWithFetchRequest:(NSFetchRequest *)fetchRequest
                managedObjectContext:(NSManagedObjectContext *)context
                  sectionNameKeyPath:(NSString *)sectionNameKeyPath
                           cacheName:(NSString *)name
{
    self = [super initWithFetchRequest:fetchRequest
                  managedObjectContext:context
                    sectionNameKeyPath:sectionNameKeyPath
                             cacheName:name];
    
    if (self)
    {
        self.delegate = self;
    }
    
    return self;
}

- (NSIndexPath *)normalizeIndexPath:(NSIndexPath *)indexPath
{
    return [NSIndexPath indexPathForRow:indexPath.row
                              inSection:indexPath.section + self.sectionOffset];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.objectChanges = @{
                           @(NSFetchedResultsChangeInsert): [[NSMutableArray alloc] init],
                           @(NSFetchedResultsChangeDelete): [[NSMutableArray alloc] init],
                           @(NSFetchedResultsChangeUpdate): [[NSMutableArray alloc] init],
                           @(NSFetchedResultsChangeMove): [[NSMutableArray alloc] init]
                           };
    
    self.sectionChanges = @{
                            @(NSFetchedResultsChangeInsert): [[NSMutableIndexSet alloc] init],
                            @(NSFetchedResultsChangeDelete): [[NSMutableIndexSet alloc] init],
                            };

    self.excludedSections = [[NSMutableIndexSet alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSMutableIndexSet *changeSet = self.sectionChanges[@(type)];
    [changeSet addIndex:sectionIndex + self.sectionOffset];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSMutableArray *changeSet = self.objectChanges[@(type)];
    
    NSIndexPath *actualIndexPath = [self normalizeIndexPath:indexPath];
    NSIndexPath *actualNewIndexPath = [self normalizeIndexPath:newIndexPath];
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [changeSet addObject:actualNewIndexPath];
            
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [changeSet addObject:actualIndexPath];
            
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [changeSet addObject:actualIndexPath];
            
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            [changeSet addObject:@[actualIndexPath, actualNewIndexPath]];
            
            [self.excludedSections addIndex:actualIndexPath.section];
            [self.excludedSections addIndex:actualNewIndexPath.section];
            
            break;
        }
    }
}

- (NSArray *)normalizeObjectMoves
{
    NSMutableArray *moves = self.objectChanges[@(NSFetchedResultsChangeMove)];
    NSMutableArray *updatedMoves = [[NSMutableArray alloc] init];
    
    if (moves.count > 0)
    {
        NSMutableIndexSet *insertSections = self.sectionChanges[@(NSFetchedResultsChangeInsert)];
        NSMutableIndexSet *deleteSections = self.sectionChanges[@(NSFetchedResultsChangeDelete)];
        
        for (NSArray *move in moves)
        {
            NSIndexPath *fromIP = move[0];
            NSIndexPath *toIP = move[1];
            
            if ([deleteSections containsIndex:fromIP.section] &&
                ![insertSections containsIndex:toIP.section])
            {
                NSMutableArray *changeSet = self.objectChanges[@(NSFetchedResultsChangeInsert)];
                [changeSet addObject:toIP];
            }
            else if ([insertSections containsIndex:toIP.section])
            {
                NSMutableArray *changeSet = self.objectChanges[@(NSFetchedResultsChangeDelete)];
                [changeSet addObject:fromIP];
            }
            else
            {
                [updatedMoves addObject:move];
            }
        }
    }
    
    return updatedMoves;
}

- (NSArray *)normalizeObjectDeletes
{
    NSArray *deletes = self.objectChanges[@(NSFetchedResultsChangeDelete)];
    NSMutableIndexSet *deletedSections = self.sectionChanges[@(NSFetchedResultsChangeDelete)];
    
    return [deletes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSIndexPath *evaluatedObject, NSDictionary *bindings)
                                                 {
                                                     return ![deletedSections containsIndex:evaluatedObject.section] &&
                                                     ([self.collectionView numberOfSections] > evaluatedObject.section) &&
                                                     ([self.collectionView numberOfItemsInSection:evaluatedObject.section] > 1);
                                                 }]];
}

- (NSArray *)normalizeObjectInserts
{
    NSArray *inserts = self.objectChanges[@(NSFetchedResultsChangeInsert)];
    
    NSMutableIndexSet *insertedSections = self.sectionChanges[@(NSFetchedResultsChangeInsert)];
    return [inserts filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSIndexPath *evaluatedObject, NSDictionary *bindings)
                                                 {
                                                     return ![insertedSections containsIndex:evaluatedObject.section] &&
                                                     ([self.collectionView numberOfSections] > evaluatedObject.section);
                                                 }]];
}

- (NSIndexSet *)normalizeSectionInserts
{
    NSIndexSet *insertedSections = self.sectionChanges[@(NSFetchedResultsChangeInsert)];
    NSMutableIndexSet *newInsertedSections = [[NSMutableIndexSet alloc] init];
    
    [insertedSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         if ([self.collectionView numberOfSections] < idx)
         {
             [newInsertedSections addIndex:idx];
         }
     }];
    
    return  [newInsertedSections copy];
}

- (NSIndexSet *)normalizeSectionDeletes
{
    NSIndexSet *deletedSections = self.sectionChanges[@(NSFetchedResultsChangeDelete)];
    NSMutableIndexSet *newDeletedSections = [[NSMutableIndexSet alloc] init];
    
    [deletedSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         if ([self.collectionView numberOfSections] > 1)
         {
             [newDeletedSections addIndex:idx];
         }
     }];
    
    return  [newDeletedSections copy];
}

- (NSIndexSet *)normalizeSectionUpdates
{
    NSIndexSet *deletedSections = self.sectionChanges[@(NSFetchedResultsChangeDelete)];
    NSIndexSet *insertedSections = self.sectionChanges[@(NSFetchedResultsChangeInsert)];
    
    NSMutableIndexSet *newReloadableSections = [[NSMutableIndexSet alloc] init];
    
    for (NSInteger idx = 0; idx < [self.collectionView numberOfSections]; idx ++)
    {
        if (![deletedSections containsIndex:idx] &&
            ![insertedSections containsIndex:idx] &&
            ![self.excludedSections containsIndex:idx])
        {
            [newReloadableSections addIndex:idx];
        }
    }
    
    return newReloadableSections;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSIndexSet *deletedSections = [self normalizeSectionDeletes];
    NSIndexSet *insertedSections = [self normalizeSectionInserts];
    NSIndexSet *updatedSections = [self normalizeSectionUpdates];
    
    NSArray *deletedItems = [self normalizeObjectDeletes];
    NSArray *insertedItems = [self normalizeObjectInserts];
    NSArray *updatedItems = self.objectChanges[@(NSFetchedResultsChangeUpdate)];
    NSArray *movedItems = [self normalizeObjectMoves];
    
    [self.collectionView performBatchUpdates:^
     {
         if (deletedSections.count)
         {
             [self.collectionView deleteSections:deletedSections];
         }
         
         if (insertedSections.count)
         {
             [self.collectionView insertSections:insertedSections];
         }
         
         if (updatedSections.count)
         {
             [self.collectionView reloadSections:updatedSections];
         }
         
         if (deletedItems.count)
         {
             [self.collectionView deleteItemsAtIndexPaths:deletedItems];
         }
         
         if (insertedItems.count)
         {
             [self.collectionView insertItemsAtIndexPaths:insertedItems];
         }
         
         if (updatedItems.count)
         {
             [self.collectionView reloadItemsAtIndexPaths:updatedItems];
         }
         
         for (NSArray *paths in movedItems)
         {
             [self.collectionView moveItemAtIndexPath:paths[0]
                                          toIndexPath:paths[1]];
         }
         
     }
                                  completion:nil];
    
    [self.dataDelegate didUpdateContent];
    
    self.objectChanges = nil;
    self.sectionChanges = nil;
    self.excludedSections = nil;
}

@end