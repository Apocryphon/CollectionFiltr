//
//  RYFilterListTableViewController.h
//  CollectionFiltr
//
//  Created by Richard Yeh on 10/23/16.
//  Copyright © 2016 Richard Yeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RYFilterListTableViewDelegate <NSObject>
@required
- (void)selectedFilterName:(NSString *)filterName;         // returns selected filter back to collection view 
@end

@interface RYFilterListTableViewController : UITableViewController <UITableViewDelegate>
@property (nonatomic, weak) id<RYFilterListTableViewDelegate> delegate;
@end
