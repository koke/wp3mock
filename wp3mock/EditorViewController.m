//
//  EditorViewController.m
//  wp3mock
//
//  Created by Jorge Bernal on 11/11/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import "EditorViewController.h"

@implementation EditorViewController
@synthesize titleTextField;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.titleTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return SHOULD_AUTOROTATE_TO(interfaceOrientation);
}


- (IBAction)dismiss:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    NSString *title = titleTextField.text;
    if (title == nil || [title isEqualToString:@""]) {
        title = @"<Untitled post>";
    }
    NSDictionary *newPost = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewPost" object:newPost];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
