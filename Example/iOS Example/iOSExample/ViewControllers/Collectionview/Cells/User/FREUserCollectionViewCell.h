//
//  FREUserCollectionViewCell.h
//  iOSExample
//
//  Created by William Boles on 18/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FREUserCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *ageLabel;

+ (NSString *)reuseIdentifier;

- (void)layoutByApplyingConstraints;

@end
