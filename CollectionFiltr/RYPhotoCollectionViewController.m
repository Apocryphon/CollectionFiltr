//
//  RYPhotoCollectionViewController.m
//  CollectionFiltr
//
//  Created by Richard Yeh on 10/22/16.
//  Copyright © 2016 Richard Yeh. All rights reserved.
//

#import "RYPhotoCollectionViewController.h"
#import "RCYPhotoCell.h"

@import Photos;

@interface RYPhotoCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *userPhotos;
@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;
@property (nonatomic, strong) CIContext *imageContext;
@property (nonatomic, strong) CIFilter *currentFilter;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterListButton;
@end

@implementation RYPhotoCollectionViewController

static NSString *const reuseIdentifier = @"PhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    // fetch all photos from Camera Roll
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage
                                                         options:allPhotosOptions];
    
    self.userPhotos = [[NSMutableArray alloc] initWithCapacity:[allPhotos count]];
    
    for (PHAsset *currentPhoto in allPhotos) {
        [self.userPhotos addObject:currentPhoto];
    }
    
    // batch pre-cache images
    self.cachingImageManager = [[PHCachingImageManager alloc] init];
    [self.cachingImageManager startCachingImagesForAssets:self.userPhotos
                                               targetSize:PHImageManagerMaximumSize
                                              contentMode:PHImageContentModeAspectFit
                                                  options:nil];
    
    // setup Core Image properties
    self.imageContext = [CIContext contextWithOptions:nil];
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    // segue for popover with list of filters
    if ([segue.identifier isEqualToString:@"showFilterListPopoverSegue"]) {
        RYFilterListTableViewController *filterListTableVC = [segue destinationViewController];
        filterListTableVC.popoverPresentationController.delegate = self;
        filterListTableVC.popoverPresentationController.popoverLayoutMargins = UIEdgeInsetsMake(0.0, 0.0, -20.0, 0.0); // ignored: iOS bug (http://www.openradar.me/26290990)
        filterListTableVC.preferredContentSize = CGSizeMake(200, 450);
        filterListTableVC.delegate = self;
    }

}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    // Configure the cell
    if (cell.tag) {
        [self.cachingImageManager cancelImageRequest:(PHImageRequestID)cell.tag];
    }

    // for fast loading of initial images
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.synchronous = true;
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;

    // result handler that applies selected image filter
    __weak typeof(self) weakSelf = self;
    void (^resultHandler)(UIImage *, NSDictionary *) = ^(UIImage * _Nullable initialResult, NSDictionary * _Nullable info) {
         if (!weakSelf.currentFilter) {
            cell.photoImageView.image = initialResult;
            return;
        } else {
            CIImage *beginImage = [[CIImage alloc] initWithCGImage:initialResult.CGImage options:nil];
            [_currentFilter setValue:beginImage forKey:kCIInputImageKey];
            CIImage *outputImage = [_currentFilter outputImage];
            
            CGImageRef cgimg = [_imageContext createCGImage:outputImage fromRect:[outputImage extent]];
            
            UIImage *filteredImage = [UIImage imageWithCGImage:cgimg];
            cell.photoImageView.image = filteredImage;
            
            CGImageRelease(cgimg);
            return;

        }
    };

    cell.tag = [self.cachingImageManager requestImageForAsset:[self.userPhotos objectAtIndex:indexPath.row]
                                  targetSize:CGSizeMake(100.0, 100.0)
                                 contentMode:PHImageContentModeAspectFill
                                     options:requestOptions
                               resultHandler:resultHandler];

    
    return cell;
}

#pragma mark - List of Filters

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

// image filters defined here
- (void)selectedFilter:(RYCIFilter)filterEnum {
    switch (filterEnum) {

        case RYCIPhotoEffectChrome:
            self.currentFilter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];
            break;
        case RYCIComicEffect:
            self.currentFilter = [CIFilter filterWithName:@"CIComicEffect"];
            break;
        case RYCICrystallize:
            self.currentFilter = [CIFilter filterWithName:@"CICrystallize"];
            break;
        case RYCIGaussianBlur:
            self.currentFilter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:@"inputRadius", @8.0, nil];
            break;
        case RYCIPhotoEffectInstant:
            self.currentFilter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
            break;
        case RYCIPhotoEffectMono:
            self.currentFilter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
            break;
        case RYCIPhotoEffectNoir:
            self.currentFilter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
            break;
        case RYCIPhotoEffectProcess:
            self.currentFilter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
            break;
        case RYCISepiaTone:
            self.currentFilter = [CIFilter filterWithName:@"CISepiaTone"];
            break;
        case RYCIVignetteEffect:
            self.currentFilter = [CIFilter filterWithName:@"CIVignetteEffect"];
            break;
            
        default:
            break;
    }
    
    [self.collectionView reloadData];

}

- (IBAction)resetFilters:(id)sender {
    if (self.currentFilter) {
        self.currentFilter = nil;
        [self.collectionView reloadData];
    }
}

@end
