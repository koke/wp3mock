//
//  ReaderViewController.h
//  wp3mock
//
//  Created by Jorge Bernal on 11/11/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReaderViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong) NSURL *url;
@property (strong) NSURL *urlToLoad;
- (void)reloadWebView;
@end
