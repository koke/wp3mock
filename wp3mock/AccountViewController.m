//
//  AccountViewController.m
//  wp3mock
//
//  Created by Jorge Bernal on 11/11/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import "AccountViewController.h"


@implementation AccountViewController
@synthesize blogs = __blogs;
@synthesize editButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.blogs = [NSMutableArray arrayWithObjects:
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"My Blog", @"title", @"myblog.wordpress.com", @"url", [NSNumber numberWithBool:YES], @"enabled", nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"My Older blog", @"title", @"nothinghere.wordpress.com", @"url", [NSNumber numberWithBool:NO], @"enabled", nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"A photo blog", @"title", @"aphotoblog.wordpress.com", @"url", [NSNumber numberWithBool:YES], @"enabled", nil],
                  nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.blogs = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return SHOULD_AUTOROTATE_TO(interfaceOrientation);
}

#pragma mark - Table View methods

- (NSArray *)enabledBlogs {
    return [self.blogs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"enabled = 1"]];    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%@ %@", self, NSStringFromSelector(_cmd));
    if (section == 0) {
        if (editing) {
            NSLog(@"section %d: %d", section, self.blogs.count);
            return self.blogs.count;
        } else {
            NSLog(@"section %d: %d", section, [[self enabledBlogs] count]);
            return [[self enabledBlogs] count];
        }
    } else {
        NSLog(@"section %d: 1", section);
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Blogs";
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    int diff = [self.blogs count] - [[self enabledBlogs] count];
    if (!editing && section == 0 && diff > 0) {
        return [NSString stringWithFormat:@"And %d hidden blogs. Tap edit to see them", diff];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@ %@", self, NSStringFromSelector(_cmd));
    NSLog(@"cell @ %d,%d", indexPath.section, indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlogCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BlogCell"] autorelease];
    }
    if (indexPath.section == 0) {
        NSArray *blogs = editing ? [self blogs] : [self enabledBlogs];
        NSLog(@"blogs: %@", blogs);
        NSMutableDictionary *blog = [blogs objectAtIndex:indexPath.row];
        cell.textLabel.text = [blog objectForKey:@"title"];
        cell.detailTextLabel.text = [blog objectForKey:@"url"];
        cell.imageView.image = [UIImage imageNamed:@"asdf"];
        if (editing) {
            BOOL enabled = [[blog objectForKey:@"enabled"] boolValue];
            cell.accessoryType = (enabled) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Change password";
        } else {
            cell.textLabel.text = @"Notifications";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@ %@", self, NSStringFromSelector(_cmd));
    if (editing) {
        NSMutableDictionary *blog = [self.blogs objectAtIndex:indexPath.row];
        BOOL enabled = [[blog objectForKey:@"enabled"] boolValue];
        [blog setObject:[NSNumber numberWithBool:!enabled] forKey:@"enabled"];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        if (indexPath.section == 0) {
            [self performSegueWithIdentifier:@"showBlog" sender:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 && ! editing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *blog = [[self enabledBlogs] objectAtIndex:indexPath.row];
    BOOL enabled = [[blog objectForKey:@"enabled"] boolValue];
    [blog setObject:[NSNumber numberWithBool:!enabled] forKey:@"enabled"];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Custom methods

- (IBAction)edit:(id)sender {
    editing = ! editing;
    if (editing) {
        editButton.title = @"Done";
        editButton.style = UIBarButtonItemStyleDone;
    } else {
        editButton.title = @"Edit";
        editButton.style = UIBarButtonItemStyleBordered;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

@end
