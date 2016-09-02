//
//  EMallUITests.m
//  EMallUITests
//
//  Created by netease on 16/9/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EMallUITests-Bridging-Header.h"
#import "EMallUITests-Swift.h"
@interface EMallUITests : XCTestCase

@end

@implementation EMallUITests


- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication *app= [[XCUIApplication alloc] init];
    [Snapshot setupSnapshot:app];
    [app launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardo         wn code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self homeController];
    [self discoveryController];
}
- (void)homeController{
    [Snapshot snapshot:@"HomeController" waitForLoadingIndicator:YES];
}
- (void)discoveryController{
    [Snapshot snapshot:@"DiscoverController" waitForLoadingIndicator:YES];
}
- (void)goodsDetailoController{
    [Snapshot snapshot:@"GoodsDetailController" waitForLoadingIndicator:YES];
}
- (void)shopCartController{
    [Snapshot snapshot:@"ShopCartController" waitForLoadingIndicator:YES];
}
- (void)meController{
    [Snapshot snapshot:@"MeController" waitForLoadingIndicator:YES];
}
@end
