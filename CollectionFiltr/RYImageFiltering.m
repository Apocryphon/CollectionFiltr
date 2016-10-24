//
//  RYImageFiltering.m
//  CollectionFiltr
//
//  Created by Richard Yeh on 10/24/16.
//  Copyright © 2016 Richard Yeh. All rights reserved.
//

#import "RYImageFiltering.h"

@implementation RYImageFiltering

- (id)initWithUIImage:(UIImage *)image imageFilter:(CIFilter *)filter imageContext:(CIContext *)context indexPath:(NSIndexPath *)indexPath delegate:(id<RYImageFilteringDelegate>)thisDelegate{
    if (self = [super init]) {
        self.delegate = thisDelegate;
        self.initialImage = image;
        self.imageFilter = filter;
        self.imageContext = context;
        self.currentIndexPath = indexPath;
    }
    return self;
}

- (void)main {
    @autoreleasepool {
        if (self.isCancelled)
            return;
        
        if (!self.initialImage)
            return;
        
        CIImage *initialCIImage = [[CIImage alloc] initWithCGImage:self.initialImage.CGImage options:nil];
        
        if (self.isCancelled)
            return;
        
        [self.imageFilter setValue:initialCIImage forKey:kCIInputImageKey];
        CIImage *outputImage = [self.imageFilter outputImage];
        
        if (self.isCancelled)
            return;
        
        CGImageRef cgimg = [self.imageContext createCGImage:outputImage fromRect:[outputImage extent]];
        
        if (self.isCancelled) {
            CGImageRelease(cgimg);
            return;
        }
        
        self.filteredImage = [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);
        
        if (self.isCancelled)
            return;
        
        if (self.filteredImage) {
            [(NSObject *)self.delegate performSelector:@selector(imageFilteringDone:) withObject:self];
        }


    }
}

@end
