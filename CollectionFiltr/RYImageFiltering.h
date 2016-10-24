//
//  RYImageFiltering.h
//  CollectionFiltr
//
//  Created by Richard Yeh on 10/24/16.
//  Copyright © 2016 Richard Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import CoreImage;

@protocol RYImageFilteringDelegate;

@interface RYImageFiltering : NSOperation
@property (nonatomic, weak) id <RYImageFilteringDelegate> delegate;
@property (nonatomic, strong) UIImage *initialImage;
@property (nonatomic, strong) CIFilter *imageFilter;
@property (nonatomic, strong) CIContext *imageContext;
@property (nonatomic, strong) UIImage *filteredImage;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

- (id)initWithUIImage:(UIImage *)image imageFilter:(CIFilter *)filter imageContext:(CIContext *)context indexPath:(NSIndexPath *)indexPath delegate:(id<RYImageFilteringDelegate>)thisDelegate;

@end

@protocol RYImageFilteringDelegate <NSObject>
- (void)imageFilteringDone:(RYImageFiltering *)filtration;
@end