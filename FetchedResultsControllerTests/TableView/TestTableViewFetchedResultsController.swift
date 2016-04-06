//
//  TableViewFetchedResultsControllerDelegate.swift
//  FetchedResultsController
//
//  Created by William Boles on 04/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit
import XCTest

class TestTableViewFetchedResultsController: NSObject, TableViewFetchedResultsControllerDelegate {
    
    //MARK: Accessors
    
    var didUpdateContentDelegateMethodCalled: Bool = false
    var didChangeIndexPathsDelegateMethodCalled: Bool = false
    var didUpdateIndexPathDelegateMethodCalled: Bool = false
    
    var didChangeIndexPathsInsertedArray: Array<NSIndexPath>?
    var didChangeIndexPathsUpdatedArray: Array<NSIndexPath>?
    
    var didUpdateIndexPathIndexPath: NSIndexPath?
    
    //MARK: TableViewFetchedResultsControllerDelegate
    
    func didUpdateContent() {
        self.didUpdateContentDelegateMethodCalled = true
    }
    
    func didChangeIndexPaths(insertedIndexPaths: Array<NSIndexPath>, updatedIndexPaths: Array<NSIndexPath>) {
        self.didChangeIndexPathsInsertedArray = insertedIndexPaths
        self.didChangeIndexPathsUpdatedArray = updatedIndexPaths
        
        self.didChangeIndexPathsDelegateMethodCalled = true
    }
    
    func didUpdateIndexPath(indexPath: NSIndexPath) {
        self.didUpdateIndexPathIndexPath = indexPath
        
        self.didUpdateIndexPathDelegateMethodCalled = true
    }
}
