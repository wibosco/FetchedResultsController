//
//  FRCTableViewFetchedResultsController.h
//  FetchedResultsController
//
//  Created by William Boles on 29/01/2015.
//  Copyright (c) 2015 Boles. All rights reserved.
//

@import CoreData;
@import Foundation;
@import UIKit;

@protocol FRCTableViewFetchedResultsControllerDataDelegate <NSObject>

/**
 Informational call for when the FRC updates
 */
- (void)didUpdateContent;

@optional
/**
 Informational call for when the FRC updates.
 
 @param insertedIndexPaths - array of inserted objects;
 */
- (void)didChangeWithInsertObjectsAtIndexPaths:(NSArray *)insertedIndexPaths
                             updatedIndexPaths:(NSArray *)updatedIndexPaths;

/**
 Informational call for when the FRC updates.

 @param indexPath - indexPath to the updated cell.
 */
- (void)didUpdateItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface FRCTableViewFetchedResultsController : NSFetchedResultsController <NSFetchedResultsControllerDelegate>

/**
 Table view for the fetch result controller to update.
 */
@property (atomic, weak) UITableView *tableView;

/**
 Delegate for the fetch result controller updates.
 */
@property (atomic, weak) id<FRCTableViewFetchedResultsControllerDataDelegate> dataDelegate;

/**
 This is the value to offset the section indexes by.
 
 This allows a tableview to support FRC and have non-FRC sections. The non-FRC sections must come before the FRC section.
 */
@property (nonatomic, assign) NSUInteger sectionOffset;

/**
 Animation effect on a insert row action.
 */
@property (nonatomic, assign) UITableViewRowAnimation insertRowAnimation;

/**
 Animation effect on a delete row action.
 */
@property (nonatomic, assign) UITableViewRowAnimation deleteRowAnimation;

/**
 Animation effect on a update row action.
 */
@property (nonatomic, assign) UITableViewRowAnimation updateRowAnimation;

/**
 Animation effect on a insert section action.
 */
@property (nonatomic, assign) UITableViewRowAnimation insertSectionAnimation;

/**
 Animation effect on a delete section action.
 */
@property (nonatomic, assign) UITableViewRowAnimation deleteSectionAnimation;

/**
 Tells the fetch request controller to clear it's cache.
 */
- (void)clearCache;

@end
