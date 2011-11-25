//
//  QuickPostViewController.m
//  wp3mock
//
//  Created by Jorge Bernal on 11/16/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import "QuickPostViewController.h"
#import "QuickPhotoViewController.h"

@implementation QuickPostViewController
@synthesize items = __items;
@synthesize tableView = __tableView;

- (void)dealloc {
    self.tableView = nil;
    [__items release]; __items = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        __items = [[NSMutableArray array] retain];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"NewPost" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [self newPost:(NSDictionary *)note.object];
        }];
    }
    return self;
}

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self newPost:[NSDictionary dictionaryWithObject:@"A test post" forKey:@"title"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)subtitleForProgress:(float)progress {
    if (progress >= 1.0f) {
        return @"Published";
    } else if (progress >= 0.0f) {
        int pctg = (int)(progress * 100);
        return [NSString stringWithFormat:@"Uploading: %d%%", pctg];
    } else {
        [TestFlight passCheckpoint:@"Upload failed"];
        return @"Failed, tap to retry";
    }
}

- (void)postTimer:(NSTimer *)timer {
    float progress = [[timer.userInfo objectForKey:@"progress"] floatValue];
    NSDictionary *userInfo = timer.userInfo;
    NSLog(@"postTimer (%f): %@", progress, userInfo);
    if (progress >= 0.0f) {
        int r = arc4random() % 15;
        NSLog(@"Should we fail? r:%d", r);
        if (r == 0) {
            progress = -1.0f;
            NSLog(@"Invalidating");
            [timer invalidate];
        } else {
            progress += 0.1f;
        }
    }
    if (progress >= 1.0f) {
        [timer invalidate];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[__items indexOfObject:userInfo] inSection:0];
    [userInfo setValue:[NSNumber numberWithFloat:progress] forKey:@"progress"];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = [self subtitleForProgress:progress];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)startUpload:(NSMutableDictionary *)post {
    float progress = [[post objectForKey:@"progress"] floatValue];
    if (progress >= 0.0f && progress <= 1.0f) {
        NSLog(@"already uploading, don't start");
        return;
    }
    [post setObject:[NSNumber numberWithFloat:0.0f] forKey:@"progress"];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(postTimer:) userInfo:post repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];    
}

- (void)newPost:(NSDictionary *)post {
    NSMutableDictionary *newPost = [post mutableCopy];
    [newPost addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:-1.0f] forKey:@"progress"]];
    [__items addObject:newPost];
    [__tableView reloadData];
    [self startUpload:newPost];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"quickPhotoCamera"]) {
        QuickPhotoViewController *qpController = (QuickPhotoViewController *)segue.destinationViewController;
        qpController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([segue.identifier isEqualToString:@"quickPhotoLibrary"]) {
        QuickPhotoViewController *qpController = (QuickPhotoViewController *)segue.destinationViewController;
        qpController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numRows: %d", __items.count);
    return __items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell @ %d", indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuickPostCell"];
    NSDictionary *item = [__items objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"title"];
    cell.detailTextLabel.text = [self subtitleForProgress:[[item objectForKey:@"progress"] floatValue]];
    UIImage *thumbnail = [item objectForKey:@"image"];
    if (thumbnail) {
        cell.imageView.image = thumbnail;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __tableView.bounds.size.width, 40.0f)];
    headerLabel.text = @"Posts";
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    headerLabel.textColor = [UIColor darkGrayColor];
    return headerLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *post = [__items objectAtIndex:indexPath.row];
    [self startUpload:post];
    [TestFlight passCheckpoint:@"Retried upload"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
