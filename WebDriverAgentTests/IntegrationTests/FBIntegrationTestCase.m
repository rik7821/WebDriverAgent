/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <XCTest/XCTest.h>

#import "FBSpringboardApplication.h"
#import "FBTestMacros.h"
#import "FBIntegrationTestCase.h"
#import "FBRunLoopSpinner.h"
#import "XCUIElement.h"
#import "XCUIElement+FBIsVisible.h"

NSString *const FBShowAlertButtonName = @"Create App Alert";
NSString *const FBShowSheetAlertButtonName = @"Create Sheet Alert";

@interface FBIntegrationTestCase ()
@property (nonatomic, strong) XCUIApplication *testedApplication;
@end

@implementation FBIntegrationTestCase

- (void)setUp
{
  [super setUp];
  self.continueAfterFailure = NO;
  self.testedApplication = [XCUIApplication new];
  [self.testedApplication launch];
  FBAssertWaitTillBecomesTrue(self.testedApplication.buttons[@"Alerts"].fb_isVisible);
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];

  // Force resolving XCUIApplication
  [self.testedApplication query];
  [self.testedApplication resolve];
}

- (void)goToAttributesPage
{
  [self.testedApplication.buttons[@"Attributes"] tap];
  FBAssertWaitTillBecomesTrue(self.testedApplication.buttons[@"Button"].fb_isVisible);
}

- (void)goToAlertsPage
{
  [self.testedApplication.buttons[@"Alerts"] tap];
  FBAssertWaitTillBecomesTrue(self.testedApplication.buttons[FBShowAlertButtonName].fb_isVisible);
}

- (void)goToContacts
{
  [self.testedApplication.buttons[@"Contacts"] tap];
  FBAssertWaitTillBecomesTrue(self.testedApplication.navigationBars.buttons[@"Cancel"].fb_isVisible);
}

- (void)goToSpringBoardFirstPage
{
  [[XCUIDevice sharedDevice] pressButton:XCUIDeviceButtonHome];
  FBAssertWaitTillBecomesTrue([FBSpringboardApplication fb_springboard].icons[@"Safari"].exists);
  [[XCUIDevice sharedDevice] pressButton:XCUIDeviceButtonHome];
  FBAssertWaitTillBecomesTrue([FBSpringboardApplication fb_springboard].icons[@"Calendar"].fb_isVisible);
}

- (void)goToScrollPageWithCells:(BOOL)showCells
{
  [self.testedApplication.buttons[@"Scrolling"] tap];
  FBAssertWaitTillBecomesTrue(self.testedApplication.buttons[@"TableView"].fb_isVisible);
  [self.testedApplication.buttons[showCells ? @"TableView": @"ScrollView"] tap];
  FBAssertWaitTillBecomesTrue(self.testedApplication.staticTexts[@"3"].fb_isVisible);
}

@end
