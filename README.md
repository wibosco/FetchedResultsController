[![Version](https://img.shields.io/cocoapods/v/FetchedResultsController.svg?style=flat)](http://cocoapods.org/pods/FetchedResultsController)
[![License](https://img.shields.io/cocoapods/l/FetchedResultsController.svg?style=flat)](http://cocoapods.org/pods/FetchedResultsController)
[![Platform](https://img.shields.io/cocoapods/p/FetchedResultsController.svg?style=flat)](http://cocoapods.org/pods/FetchedResultsController)

A FetchedResultsController implementation that abstracts out the boilerplate for both UITableView and UICollectionView

##Installation

FetchedResultsController is intended to be installed via [Cocoapods](https://cocoapods.org/) 

CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the [Getting Started Guide](https://guides.cocoapods.org/using/getting-started.html). You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build FetchedResultsController.

#### Podfile

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

##Using this pod

FetchedResultsController uses [modules](http://useyourloaf.com/blog/modules-and-precompiled-headers.html) for importing/using frameworks - you will need to enable this in your project.

##Found an issue?

Please open a [new Issue here](https://github.com/wibosco/FetchedResultsController/issues/new) if you run into a problem specific to FetchedResultsController, have a feature request, or want to share a comment. Note that general FetchedResultsController/Core Data questions should be asked on [Stack Overflow](http://stackoverflow.com).

Pull requests are encouraged and greatly appreciated! Please try to maintain consistency with the existing [code style](http://www.williamboles.me/objective-c-coding-style). If you're considering taking on significant changes or additions to the project, please communicate in advance by opening a new Issue. This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.

##Versions

To tag a version use:

```bash
git tag -a 1.1.5 -m 'Version 1.1.5'
```
