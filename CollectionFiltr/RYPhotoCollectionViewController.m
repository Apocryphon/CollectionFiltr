//
//  RYPhotoCollectionViewController.m
//  CollectionFiltr
//
//  Created by Richard Yeh on 10/22/16.
//  Copyright © 2016 Richard Yeh. All rights reserved.
//

#import "RYPhotoCollectionViewController.h"

@import Photos;

@interface RYPhotoCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *userPhotos;
@end

@implementation RYPhotoCollectionViewController

static NSString *const reuseIdentifier = @"PhotoCell";

- (void)awakeFromNib {
    
    // fetch all photos from Camera Roll
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage
                                                         options:allPhotosOptions];
    
    self.userPhotos = [[NSMutableArray alloc] initWithCapacity:[allPhotos count]];
    
    for (PHAsset *currentPhoto in allPhotos) {
        [self.userPhotos addObject:currentPhoto];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PHImageManager *manager = [PHImageManager defaultManager];

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if (cell.tag) {
        [manager cancelImageRequest:(PHImageRequestID)cell.tag];
    }

    UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:100];
    cell.tag = [manager requestImageForAsset:[self.userPhotos objectAtIndex:indexPath.row]
                                  targetSize:CGSizeMake(100.0, 100.0)
                                 contentMode:PHImageContentModeAspectFill
                                     options:nil
                               resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                            photoImageView.image = result;
                }];

    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end