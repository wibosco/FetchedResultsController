//
//  FRCCollectionViewFetchedResultsController.h
//  FetchedResultsController
//
//  Created by William Boles on on 21/05/2015.
//  Copyright (c) 2014 Boles. All rights reserved.
//

@import CoreData;
@import Foundation;
@import UIKit;

@class FRCCollectionViewFetchedResultsController;

@protocol FRCCollectionViewFetchedResultsControllerDataDelegate <NSObject>

/**
 Informational call for when the FRC updates
 */
- (void)didUpdateContent;

@end

@interface FRCCollectionViewFetchedResultsController : NSFetchedResultsController <NSFetchedResultsControllerDelegate>

/**
 Collection view for the fetch result controller to update.
 */
@property (nonatomic, weak) UICollectionView *collectionView;

/**
 Delegate for the fetch result controller updates.
 */
@property (nonatomic, weak) id<FRCCollectionViewFetchedResultsControllerDataDelegate> dataDelegate;

/**
 This is the value to offset the section indexes by.
 
 This allows a collectionview to support FRC and have non-FRC sections. The non-FRC sections must come before the FRC section.
 */
@property (nonatomic, assign) NSUInteger sectionOffset;

@end
