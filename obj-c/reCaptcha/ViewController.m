//
//  ViewController.m
//  reCaptcha
//
//  Created by ThinkChaos on 29/08/16.
//  Copyright © 2016 ThinkChaos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    WKWebView *wk;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initWebkitView];

    // Load your website: this allows reCaptcha to have the correct referrer header.
    [wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://example.com"]]];
}

- (WKUserScript*)readScript {
    NSString *scriptSrc = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"script" ofType:@"js"]
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];

    return [[WKUserScript alloc] initWithSource:scriptSrc
                                  injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                               forMainFrameOnly:true];
}

- (void)initWebkitView {
    WKUserContentController *wkController = [[WKUserContentController alloc] init];

    [wkController addScriptMessageHandler:self name:@"reCaptchaiOS"];
    [wkController addUserScript:[self readScript]];

    WKWebViewConfiguration *wkConf = [[WKWebViewConfiguration alloc] init];
    [wkConf setUserContentController:wkController];

    wk = [[WKWebView alloc] initWithFrame:self.view.frame
                            configuration:wkConf];

    wk.backgroundColor = [UIColor clearColor];
  wk.opaque = NO;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSArray<NSString*> *args = (NSArray*)message.body;

    if ([args[0] isEqualToString:@"didLoad"])
        [self captchaDidLoad];
    else if ([args[0] isEqualToString:@"didSolve"])
        [self captchaDidSolve:args[1]];
    else if ([args[0] isEqualToString:@"didExpire"])
        [self captchaDidExpire];
}

- (void)captchaDidLoad {
    [wk setFrame:self.view.frame];
    [self.view addSubview:wk];
}

- (void)captchaDidSolve:(NSString *)response {
    NSLog(@"%@", response);
}

- (void)captchaDidExpire {
    NSLog(@"Captcha expired");
}

@end
