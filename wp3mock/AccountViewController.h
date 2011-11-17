//
//  AccountViewController.h
//  wp3mock
//
//  Created by Jorge Bernal on 11/11/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UITableViewController {
    BOOL editing;
}
@property (strong) NSMutableArray *blogs;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)edit:(id)sender;
@end
