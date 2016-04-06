//
//  TableViewFetchedResultsController.swift
//  FetchedResultsController
//
//  Created by Home on 02/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit
import CoreData

/**
 Delegate for when the tableview's content changes in the FRC.
 */
@objc public protocol TableViewFetchedResultsControllerDelegate: NSObjectProtocol {
    
    /**
     Informational call for when the FRC updates.
     */
    optional func didUpdateContent()
    
    /**
     Informational call for when the FRC updates.
     
     - param insertedIndexPaths: array of inserted index paths.
     - param updatedIndexPaths: array of updated index paths.
     */
    optional func didChangeIndexPaths(insertedIndexPaths: Array<NSIndexPath>, updatedIndexPaths: Array<NSIndexPath>)
    
    /**
     Informational call for when the FRC updates.
     
     - param indexPath: indexPath to the updated cell.
     */
    optional func didUpdateIndexPath(indexPath: NSIndexPath);
}

/**
 A tableview supported subclass of `NSFetchedResultsController`.
 */
@objc public class TableViewFetchedResultsController: NSFetchedResultsController, NSFetchedResultsControllerDelegate {
    
    //MARK: Accessors
    
    /**
     Table view for the fetch result controller to update.
     */
    public weak var tableView: UITableView?
    
    /**
     Delegate for the fetch result controller updates.
     */
    public weak var dataDelegate: TableViewFetchedResultsControllerDelegate?
    
    /**
     This is the value to offset the section indexes by.
     
     This allows a tableview to support FRC and have non-FRC sections. The non-FRC sections must come before the FRC section.
     */
    public var sectionOffset = 0
    
    /**
     Animation effect on a insert row action.
     */
    public var insertRowAnimation: UITableViewRowAnimation = UITableViewRowAnimation.Automatic
    
    /**
     Animation effect on a delete row action.
     */
    public var deleteRowAnimation: UITableViewRowAnimation = UITableViewRowAnimation.Automatic
    
    /**
     Animation effect on a update row action.
     */
    public var updateRowAnimation: UITableViewRowAnimation = UITableViewRowAnimation.Automatic
    
    /**
     Animation effect on a insert section action.
     */
    public var insertSectionAnimation: UITableViewRowAnimation = UITableViewRowAnimation.Automatic
    
    /**
     Animation effect on a delete section action.
     */
    public var deleteSectionAnimation: UITableViewRowAnimation = UITableViewRowAnimation.Automatic
    
    /**
     Disables all animations when updating table view.
     */
    public var disableAnimations = false
    
    /**
     A collection of inserted index paths for that change event that will be passed through the `dataDelegate`
     */
    private var insertedIndexPaths: Array<NSIndexPath>?
    
    /**
     A collection of updated index paths for that change event that will be passed through the `dataDelegate`
     */
    private var updatedIndexPaths: Array<NSIndexPath>?
    
    //MARK: Init
    
    override init(fetchRequest: NSFetchRequest, managedObjectContext context: NSManagedObjectContext, sectionNameKeyPath: String?, cacheName name: String?) {
        super.init(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: name)
        
        self.delegate = self
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    
    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
        self.insertedIndexPaths = Array<NSIndexPath>()
        self.updatedIndexPaths = Array<NSIndexPath>()
        self.tableView?.beginUpdates()
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        var indexPathWithOffset: NSIndexPath?
        
        if indexPath != nil {
            indexPathWithOffset = NSIndexPath(forRow: (indexPath?.row)!, inSection: ((indexPath?.section)! + self.sectionOffset))
        }
        
        var newIndexPathWithOffset: NSIndexPath?
        
        if newIndexPath != nil {
            newIndexPathWithOffset = NSIndexPath(forRow: (newIndexPath?.row)!, inSection: ((newIndexPath?.section)! + self.sectionOffset))
        }
        
        /*-----------------*/
        
        switch type {
        case NSFetchedResultsChangeType.Insert:
            self.tableView?.insertRowsAtIndexPaths([newIndexPathWithOffset!], withRowAnimation: self.insertRowAnimation)
            self.insertedIndexPaths?.append(newIndexPathWithOffset!)
        case NSFetchedResultsChangeType.Delete:
            self.tableView?.deleteRowsAtIndexPaths([indexPathWithOffset!], withRowAnimation: self.deleteRowAnimation)
        case NSFetchedResultsChangeType.Update:
            self.updatedIndexPaths?.append(indexPathWithOffset!)
            self.dataDelegate?.didUpdateIndexPath?(indexPathWithOffset!)
        case NSFetchedResultsChangeType.Move:
            self.tableView?.deleteRowsAtIndexPaths([indexPathWithOffset!], withRowAnimation: self.deleteRowAnimation)
            self.tableView?.insertRowsAtIndexPaths([newIndexPathWithOffset!], withRowAnimation: self.insertRowAnimation)
        }
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case NSFetchedResultsChangeType.Insert:
            self.tableView?.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: self.insertSectionAnimation)
        case NSFetchedResultsChangeType.Delete:
            self.tableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: self.deleteRowAnimation)
        default:
            break
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if self.disableAnimations {
            UIView.setAnimationsEnabled(false)
        }
        
        // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
        self.tableView?.endUpdates()
        
        if self.disableAnimations {
            UIView.setAnimationsEnabled(true)
        }
        
        /*-----------------*/
        
        self.dataDelegate?.didChangeIndexPaths?(self.insertedIndexPaths!, updatedIndexPaths: self.updatedIndexPaths!)
        
        self.dataDelegate?.didUpdateContent?()
    }
    
    /**
     Clears the FRC's cache
     */
    public func clearCache() {
        NSFetchedResultsController.deleteCacheWithName(self.cacheName)
    }
}
