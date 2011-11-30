//
//  MasterViewController.m
//  wp3mock
//
//  Created by Jorge Bernal on 11/11/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import "MasterViewController.h"
#import "ReaderViewController.h"
#import "ActivityViewController.h"

@implementation MasterViewController
@synthesize quickPostViewController = __quickPostViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)addComment:(id)object {
    NSLog(@"addComment");
    NSDictionary *comment = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Frank", @"authorName",
                             @"frank@whales.com", @"authorEmail",
                             @"http://frank.whales.com/", @"authorUrl",
                             @"A whale walks into a bar...", @"postTitle",
                             @"Shut up Fred, you're drunk", @"content",
                             nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewComment" object:comment];
//    [self performSelector:@selector(addComment:) withObject:nil afterDelay:5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postButton.frame = CGRectMake(128, 0, 64, self.tabBar.frame.size.height);
    postButton.titleLabel.text = @"Post";
    postButton.imageView.image = [UIImage imageNamed:@"asdf"];
    [postButton addTarget:self action:@selector(quickPost:) forControlEvents:UIControlEventTouchUpInside];
//    [self.tabBar addSubview:postButton];
    [self performSelector:@selector(addComment:) withObject:nil afterDelay:5];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    // Comment next line to show login screen on launch
    loggedIn = YES;
    if (!loggedIn) {
        NSLog(@"show welcome screen");
        [self performSegueWithIdentifier:@"welcomeScreen" sender:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return SHOULD_AUTOROTATE_TO(interfaceOrientation);
}

- (void)fakeLogin {
    loggedIn = YES;
    self.selectedIndex = 3;
    UINavigationController *nav = (UINavigationController *)self.selectedViewController;
    UIViewController *accountsController = nav.topViewController;
    [accountsController performSegueWithIdentifier:@"blogWpcom" sender:accountsController];
}

- (void)showQuickPost {
    __block CGRect frame = self.view.frame;
    if (self.quickPostViewController == nil) {
        self.quickPostViewController = [[[QuickPostViewController alloc] init] autorelease];
    }
    if (quickPostView == nil) {
        frame.size.height -= self.tabBar.frame.size.height;
        quickPostView = [[UIView alloc] initWithFrame:frame];
        quickPostView.opaque = NO;
        quickPostView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [quickPostView addSubview:self.quickPostViewController.view];
    }
    quickPostView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    frame = quickPostView.bounds;
    frame.origin.y = frame.size.height;
    self.quickPostViewController.view.frame = frame;
    [self.view addSubview:quickPostView];
    [UIView animateWithDuration:0.3 animations:^{
        quickPostView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        frame.origin.y = 0;
        self.quickPostViewController.view.frame = frame;
    }];
    
    showingQuickPost = YES;
}

- (void)hideQuickPost {
    NSLog(@"view: %@", self.quickPostViewController.view);
    [UIView animateWithDuration:0.3 animations:^{
        quickPostView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    } completion:^(BOOL finished) {
        [quickPostView removeFromSuperview];
    }];

    showingQuickPost = NO;
}

- (void)quickPost:(id)sender {
    NSLog(@"QuickPost button pressed");
    if (showingQuickPost) {
        [self hideQuickPost];
    } else {
        [self showQuickPost];
    }
}

#pragma mark - TabBar controller

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"didSelectItem: %@", item.title);
    if ([item.title isEqualToString:@"Read"]) {
        UINavigationController *readerNavigation = (UINavigationController *)[self.viewControllers objectAtIndex:0];
        BOOL animated = (self.selectedIndex == 0);
        [readerNavigation popToRootViewControllerAnimated:animated];
        ReaderViewController *reader = (ReaderViewController *)readerNavigation.topViewController;
        [reader reloadWebView];
    }
}

@end
