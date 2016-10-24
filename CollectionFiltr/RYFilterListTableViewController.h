//
//  RYFilterListTableViewController.h
//  CollectionFiltr
//
//  Created by Richard Yeh on 10/23/16.
//  Copyright © 2016 Richard Yeh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RYCIFilter) {
    RYCIPhotoEffectChrome,
    RYCIComicEffect,
    RYCICrystallize,
    RYCIGaussianBlur,
    RYCIPhotoEffectInstant,
    RYCIPhotoEffectMono,
    RYCIPhotoEffectNoir,
    RYCIPhotoEffectProcess,
    RYCISepiaTone,
    RYCIVignetteEffect
};

@protocol RYFilterListTableViewDelegate <NSObject>
@required
- (void)selectedFilter:(RYCIFilter)filterEnum;         // returns selected filter back to collection view
@end

@interface RYFilterListTableViewController : UITableViewController <UITableViewDelegate>
@property (nonatomic, weak) id<RYFilterListTableViewDelegate> delegate;
@end
