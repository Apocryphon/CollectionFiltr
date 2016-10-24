//
//  RYPhotoCollectionViewController.h
//  CollectionFiltr
//
//  Created by Richard Yeh on 10/22/16.
//  Copyright © 2016 Richard Yeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYFilterListTableViewController.h"
#import "RYImageFiltering.h"

@interface RYPhotoCollectionViewController : UICollectionViewController <UIPopoverPresentationControllerDelegate, RYFilterListTableViewDelegate, RYImageFilteringDelegate>

@end
