//
//  QuickPostViewController.h
//  wp3mock
//
//  Created by Jorge Bernal on 11/16/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickPostViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *__items;
    UITableView *__tableView;
}
@property (strong) NSMutableArray *items;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
- (void)newPost:(NSDictionary *)post;
@end
