//
//  WebViewController.m
//  myMapView
//
//  Created by Aditya Narayan on 6/14/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "WebViewController.h"
#import "MapKitViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    WKWebViewConfiguration * theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView * webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    webView.navigationDelegate = self;
    NSURLRequest * nsrequest = [NSURLRequest requestWithURL:self.url];
    [webView loadRequest:nsrequest];
    
    [webView addSubview:self.backButton];
    
    [self.view addSubview:webView];
}

- (IBAction)clickBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
