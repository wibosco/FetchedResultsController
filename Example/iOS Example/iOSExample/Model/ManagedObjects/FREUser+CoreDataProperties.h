//
//  FREUser+CoreDataProperties.h
//  iOSExample
//
//  Created by William Boles on 18/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FREUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface FREUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *userID;

@end

NS_ASSUME_NONNULL_END
