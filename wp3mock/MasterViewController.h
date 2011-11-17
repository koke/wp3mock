//
//  MasterViewController.h
//  wp3mock
//
//  Created by Jorge Bernal on 11/11/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import "QuickPostViewController.h"

@interface MasterViewController : UITabBarController {
    BOOL loggedIn;
    BOOL showingQuickPost;
    UIView *quickPostView;
}
- (void)fakeLogin;
@property (nonatomic, strong) IBOutlet QuickPostViewController *quickPostViewController;
@end
