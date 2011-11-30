//
//  QuickPhotoViewController.m
//  wp3mock
//
//  Created by Jorge Bernal on 11/11/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import "QuickPhotoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation QuickPhotoViewController
@synthesize sourceType;
@synthesize photo;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [thumbnailView release]; thumbnailView = nil;
    [titleTextField release]; titleTextField = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.photo == nil) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = self.sourceType;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.sourceType]; 
        picker.delegate = self;
        [self presentModalViewController:picker animated:YES];
        [picker release];        
    } else {
        self.title = @"Quick Photo";
        thumbnailView.image = self.photo;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    picker.delegate = nil;
    [picker dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        self.title = @"Quick Photo";
        self.photo = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    } else {
        self.title = @"Quick Video";
        NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
        MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        self.photo = [mp thumbnailImageAtTime:(NSTimeInterval)2.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [mp stop];
        [mp release];
    }
    thumbnailView.image = self.photo;
    [picker dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return SHOULD_AUTOROTATE_TO(interfaceOrientation);
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    NSString *title = titleTextField.text;
    if (title == nil || [title isEqualToString:@""]) {
        title = [NSString stringWithFormat:@"A %@ post", self.title];
    }
    NSDictionary *newPost = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", self.photo, @"image", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewPost" object:newPost];

    [self.navigationController popViewControllerAnimated:YES];
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Publish %@", self.title]];
}

@end
