//
//  TableViewFetchedResultsControllerTests.swift
//  FetchedResultsController
//
//  Created by William Boles on 04/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest
import CoreData
import CoreDataServices

class TableViewFetchedResultsControllerTests: XCTestCase {
    
    //MARK: Accessors
    
    private var tableViewFetchedResultsController: TableViewFetchedResultsController {
        get {
            if _tableViewFetchedResultsController == nil {
                let fetchRequest = NSFetchRequest.fetchRequest(Test.self)
                fetchRequest!.sortDescriptors = [NSSortDescriptor(key: "testID", ascending: true)]
                
                _tableViewFetchedResultsController = TableViewFetchedResultsController(fetchRequest: fetchRequest!, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            }
            
            return _tableViewFetchedResultsController!
        }
    }
    
    private var _tableViewFetchedResultsController: TableViewFetchedResultsController?
    
    private var delegateImplementer: TestTableViewFetchedResultsController {
        get {
            if _delegateImplementer == nil {
                _delegateImplementer = TestTableViewFetchedResultsController()
            }
            
            return _delegateImplementer!
        }
    }
    
    private var _delegateImplementer: TestTableViewFetchedResultsController?
    
    var managedObjectA: Test?
    var managedObjectB: Test?
    var managedObjectC: Test?
    var managedObjectD: Test?
    
    //MARK: TestSuiteLifecycle
    
    override func setUp() {
        super.setUp()
        
        /*---------------*/
        
        ServiceManager.sharedInstance.setupModel("Model", bundle: NSBundle(forClass: TableViewFetchedResultsControllerTests.self))
        
        /*---------------*/
        
        self.managedObjectA = NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext) as? Test
        
        self.managedObjectA!.name = "Bob"
        self.managedObjectA!.testID = 19
        
        self.managedObjectB = NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext) as? Test
        
        self.managedObjectB!.name = "Toby"
        self.managedObjectB!.testID = 3
        
        self.managedObjectC = NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext) as? Test
        
        self.managedObjectC!.name = "Bob"
        self.managedObjectC!.testID = 8
        
        self.managedObjectD = NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext) as? Test
        
        self.managedObjectD!.name = "Gaby"
        self.managedObjectD!.testID = 1
        
        /*---------------*/
        
        //`Update` and `move` changes won't trigger delegate calls if we don't save our test data before hand
        ServiceManager.sharedInstance.saveMainManagedObjectContext()
    }
    
    override func tearDown() {
        
        /*---------------*/
        
        _delegateImplementer = nil
        _tableViewFetchedResultsController = nil
        
        /*---------------*/
        
        self.managedObjectA = nil
        self.managedObjectB = nil
        self.managedObjectC = nil
        self.managedObjectD = nil
        
        /*---------------*/
        
        ServiceManager.sharedInstance.clear()
        
        /*---------------*/
        
        super.tearDown()
    }
    
    //MARK: - TableViewFetchedResultsControllerDelegate
    
    //MARK: DidUpdateContent
    
    func test_dataDelegate_didUpdateContentCalledOnInsertion() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertTrue(self.delegateImplementer.didUpdateContentDelegateMethodCalled, "Should have triggered a delegate call back")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_dataDelegate_didUpdateContentCalledOnDeletion() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            ServiceManager.sharedInstance.mainManagedObjectContext.deleteObject(self.managedObjectA!)
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertTrue(self.delegateImplementer.didUpdateContentDelegateMethodCalled, "Should have triggered a delegate call back")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_dataDelegate_didUpdateContentCalledOnMove() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            self.managedObjectB?.testID = 100
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertTrue(self.delegateImplementer.didUpdateContentDelegateMethodCalled, "Should have triggered a delegate call back")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_dataDelegate_didUpdateContentCalledOnUpdate() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            self.managedObjectC?.name = "Graham"
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertTrue(self.delegateImplementer.didUpdateContentDelegateMethodCalled, "Should have triggered a delegate call back")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    //MARK: DidChangeIndexPaths
    
    func test_dataDelegate_didChangeIndexPathsCalledOnInsert() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertTrue(self.delegateImplementer.didChangeIndexPathsDelegateMethodCalled, "Should have triggered a delegate call back")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_dataDelegate_didChangeIndexPathsOnInsertCalledWithArrayOfIndexPathsReturned() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
            NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertNotNil(self.delegateImplementer.didChangeIndexPathsInsertedArray, "Expected delegate to be called with an inserted array populated")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_dataDelegate_didChangeIndexPathsOnInsertCalledWithArrayOfIndexPathsCount() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
            NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
            NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertEqual(self.delegateImplementer.didChangeIndexPathsInsertedArray!.count, 3, "Expected delegate to be called with an inserted array populated with 3 index paths")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_dataDelegate_didChangeIndexPathsCalledOnUpdate() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            self.managedObjectB?.name = "James"
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertTrue(self.delegateImplementer.didChangeIndexPathsDelegateMethodCalled, "Should have triggered a delegate call back")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_dataDelegate_didChangeIndexPathsOnUdpateCalledWithArrayOfIndexPathsReturned() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            self.managedObjectB?.name = "James"
            self.managedObjectC?.name = "Greg"
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertNotNil(self.delegateImplementer.didChangeIndexPathsInsertedArray, "Expected delegate to be called with an updated array populated")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_dataDelegate_didChangeIndexPathsOnUpdateCalledWithArrayOfIndexPathsCount() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            self.managedObjectB?.name = "James"
            self.managedObjectC?.name = "Greg"
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertEqual(self.delegateImplementer.didChangeIndexPathsUpdatedArray!.count, 2, "Expected delegate to be called with an updated array populated with 2 index paths")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    //MARK: DidUpdateIndexPath
    
    func test_dataDelegate_didUpdateIndexPathCalledOnUpdate() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            self.managedObjectB?.name = "James"
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertTrue(self.delegateImplementer.didUpdateIndexPathDelegateMethodCalled, "Should have triggered a delegate call back")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_dataDelegate_didUpdateIndexPathOnUpdateCalledWithAnyIndexPath() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            self.managedObjectB?.name = "James"
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertNotNil(self.delegateImplementer.didUpdateIndexPathIndexPath, "Expected delegate to be called with an updated index path")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_dataDelegate_didUpdateIndexPathOnUpdateCalledWithSpecficIndexPath() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            self.managedObjectB?.name = "James"
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertEqual(self.delegateImplementer.didUpdateIndexPathIndexPath!, NSIndexPath.init(forRow: 1, inSection: 0), "Specfic index path should have been updated")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    //MARK: SectionOffset
    
    func test_sectionOffset_appliedOnDidUpdateIndexPathCallBack() {
        self.tableViewFetchedResultsController.sectionOffset = 1
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            self.managedObjectB?.name = "James"
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            XCTAssertEqual(self.delegateImplementer.didUpdateIndexPathIndexPath!.section, 1, "Section should be 1")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_sectionOffset_appliedDidChangeIndexPathsUpdatedPathsArrayCallBack() {
        self.tableViewFetchedResultsController.sectionOffset = 2
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            self.managedObjectB?.name = "James"
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            let updatedIndexPath = self.delegateImplementer.didChangeIndexPathsUpdatedArray![0]
            
            XCTAssertEqual(updatedIndexPath.section, 2, "Section should be 2")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_sectionOffset_appliedDidChangeIndexPathsInsertedPathsArrayCallBack() {
        self.tableViewFetchedResultsController.sectionOffset = 3
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            let updatedIndexPath = self.delegateImplementer.didChangeIndexPathsInsertedArray![0]
            
            XCTAssertEqual(updatedIndexPath.section, 3, "Section should be 3")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func test_sectionOffset_defaultsToZero() {
        self.tableViewFetchedResultsController.dataDelegate = self.delegateImplementer
        
        do {
            try self.tableViewFetchedResultsController.performFetch()
            
            NSEntityDescription.insertNewObjectForEntity(Test.self, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
            
            ServiceManager.sharedInstance.saveMainManagedObjectContext()
            
            let updatedIndexPath = self.delegateImplementer.didChangeIndexPathsInsertedArray![0]
            
            XCTAssertEqual(updatedIndexPath.section, 0, "Section should be 0")
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }

}
