//
//  WebViewController.h
//  myMapView
//
//  Created by Aditya Narayan on 6/14/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController<WKNavigationDelegate>

@property (retain, nonatomic) NSURL * url;
@property (weak, nonatomic) IBOutlet UIButton * backButton;

- (IBAction)clickBack:(id)sender;

@end
