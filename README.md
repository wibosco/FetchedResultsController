[![Version](https://img.shields.io/cocoapods/v/FetchedResultsController.svg?style=flat)](http://cocoapods.org/pods/FetchedResultsController)
[![License](https://img.shields.io/cocoapods/l/FetchedResultsController.svg?style=flat)](http://cocoapods.org/pods/FetchedResultsController)
[![Platform](https://img.shields.io/cocoapods/p/FetchedResultsController.svg?style=flat)](http://cocoapods.org/pods/FetchedResultsController)

A FetchedResultsController implementation that abstracts out the boilerplate for both UITableView and UICollectionView

##Installation via [Cocoapods](https://cocoapods.org/)

To integrate FetchedResultsController into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'FetchedResultsController'
```

Then, run the following command:

```bash
$ pod install
```

> CocoaPods 0.39.0+ is required to build FetchedResultsController.

##Usage

FetchedResultsController is a collection of subclasses of `NSFetchedResultsController` that conform to their own `NSFetchedResultsControllerDelegate` delegate and implement these methods to handle the most common use case. As this implementation uses it's own delegate we have had to introduce a different suite of delegate callbacks: `FRCTableViewFetchedResultsControllerDataDelegate` and `FRCCollectionViewFetchedResultsControllerDataDelegate`.

####Configuring 

#####Tableview 

```objc
- (FRCTableViewFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        _fetchedResultsController = [[FRCTableViewFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                                  managedObjectContext:[CDSServiceManager sharedInstance].managedObjectContext
                                                                                    sectionNameKeyPath:nil
                                                                                             cacheName:nil];
        
        _fetchedResultsController.tableView = self.tableView;
        
        [_fetchedResultsController performFetch:nil];
    }
    
    return _fetchedResultsController;
}
```
#####Collectionview 

```objc
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
```

#####Mixing different datasources

At times you want to mix data from your FRC with data from another source inside the same `UITableView` or `UICollectionView` to support this FetchedResultsController has a `sectionOffset` property that will allow you to insert multiple non-FRC'd sections into your view. It's important to note that this only works for sections that come before (lower index) the FRC section.

```objc
_fetchedResultsController.sectionOffset = 2;
```

In the above example we add two sections before the FRC section.

> FetchedResultsController comes with an [example project](https://github.com/wibosco/FetchedResultsController/tree/master/Example/iOS%20Example) to provide more details than listed above.

> FetchedResultsController uses [modules](http://useyourloaf.com/blog/modules-and-precompiled-headers.html) for importing/using frameworks - you will need to enable this in your project.

##Found an issue?

Please open a [new Issue here](https://github.com/wibosco/FetchedResultsController/issues/new) if you run into a problem specific to FetchedResultsController, have a feature request, or want to share a comment. Note that general FetchedResultsController/Core Data questions should be asked on [Stack Overflow](http://stackoverflow.com).

Pull requests are encouraged and greatly appreciated! Please try to maintain consistency with the existing [code style](http://www.williamboles.me/objective-c-coding-style). If you're considering taking on significant changes or additions to the project, please communicate in advance by opening a new Issue. This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.
