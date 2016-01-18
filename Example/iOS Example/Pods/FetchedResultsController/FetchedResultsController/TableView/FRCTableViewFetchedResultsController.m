//
//  FRCTableViewFetchedResultsController.m
//  Boles
//
//  Created by William Boles on 29/01/2015.
//  Copyright (c) 2015 Boles. All rights reserved.
//

#import "FRCTableViewFetchedResultsController.h"

@interface FRCTableViewFetchedResultsController ()

@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedIndexPaths;

@end

@implementation FRCTableViewFetchedResultsController

#pragma mark - Init

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
        self.shouldUpdateSections = YES;
    }
    
    return self;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    self.insertedIndexPaths = [NSMutableArray new];
    self.updatedIndexPaths = [NSMutableArray new];
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath *indexPathWithOffset = [NSIndexPath indexPathForRow:indexPath.row
                                                          inSection:(indexPath.section + self.sectionOffset)];
    
    NSIndexPath *newIndexPathWithOffset = [NSIndexPath indexPathForRow:newIndexPath.row
                                                             inSection:(newIndexPath.section + self.sectionOffset)];
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPathWithOffset]
                                  withRowAnimation:self.insertRowAnimation];
            
            [self.insertedIndexPaths addObject:newIndexPathWithOffset];
            
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPathWithOffset]
                                  withRowAnimation:self.deleteRowAnimation];
            
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [self.updatedIndexPaths addObject:indexPathWithOffset];
            
            if ([self.dataDelegate respondsToSelector:@selector(didUpdateItemAtIndexPath:)])
            {
                [self.dataDelegate didUpdateItemAtIndexPath:indexPathWithOffset];
            }
            
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPathWithOffset]
                                  withRowAnimation:self.deleteRowAnimation];
            
            [self.tableView insertRowsAtIndexPaths:@[newIndexPathWithOffset]
                                  withRowAnimation:self.insertRowAnimation];
            
            break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if (self.shouldUpdateSections)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
            {
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:self.insertSectionAnimation];
                break;
            }
            case NSFetchedResultsChangeDelete:
            {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:self.deleteSectionAnimation];
                break;
            }
            default:
            {
                break;
            }
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    if (self.disableAnimations)
    {
        [UIView setAnimationsEnabled:NO];
    }
    [self.tableView endUpdates];
    if (self.disableAnimations)
    {
        [UIView setAnimationsEnabled:YES];
    }
    
    if ([self.dataDelegate respondsToSelector:@selector(didChangeWithInsertObjectsAtIndexPaths:updatedIndexPaths:)])
    {
        [self.insertedIndexPaths sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSIndexPath *indexPath1 = (NSIndexPath *)obj1;
            NSIndexPath *indexPath2 = (NSIndexPath *)obj2;
            
            NSComparisonResult result;
            
            if (indexPath1.section > indexPath2.section)
            {
                result = NSOrderedDescending;
            }
            else if (indexPath1.section < indexPath2.section)
            {
                result = NSOrderedAscending;
            }
            else
            {
                if (indexPath1.row > indexPath2.row)
                {
                    result = NSOrderedDescending;
                }
                else if (indexPath1.row < indexPath2.row)
                {
                    result = NSOrderedAscending;
                }
                else
                {
                    result = NSOrderedSame;
                }
            }
            
            return result;
        }];
        
        [self.dataDelegate didChangeWithInsertObjectsAtIndexPaths:self.insertedIndexPaths
                                                updatedIndexPaths:self.updatedIndexPaths];
    }
    
    [self.dataDelegate didUpdateContent];
}

#pragma mark - Cache

- (void)clearCache
{
    [NSFetchedResultsController deleteCacheWithName:self.cacheName];
}

@end
