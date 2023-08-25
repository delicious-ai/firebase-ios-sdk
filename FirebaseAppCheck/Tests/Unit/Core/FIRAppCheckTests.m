/*
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import <FirebaseAppCheck/FirebaseAppCheck.h>

#import "FirebaseAppCheck/Sources/Public/FirebaseAppCheck/FIRAppCheck.h"
#import "FirebaseAppCheck/Sources/Public/FirebaseAppCheck/FIRAppCheckErrors.h"
#import "FirebaseAppCheck/Sources/Public/FirebaseAppCheck/FIRAppCheckProvider.h"

#import "FirebaseAppCheck/Interop/FIRAppCheckInterop.h"
#import "FirebaseAppCheck/Interop/FIRAppCheckTokenResultInterop.h"

#import "FirebaseAppCheck/Sources/Core/Errors/FIRAppCheckErrorUtil.h"
#import "FirebaseAppCheck/Sources/Core/FIRAppCheckSettings.h"
#import "FirebaseAppCheck/Sources/Core/FIRAppCheckToken+Internal.h"
#import "FirebaseAppCheck/Sources/Core/FIRAppCheckTokenResult.h"

#import "FirebaseCore/Extension/FirebaseCoreInternal.h"

// Since DeviceCheck is the default attestation provider for AppCheck, disable
// test cases that may be dependent on DeviceCheck being available.
#if FIR_DEVICE_CHECK_SUPPORTED_TARGETS

// The FAC token value returned when an error occurs.
static NSString *const kDummyToken = @"eyJlcnJvciI6IlVOS05PV05fRVJST1IifQ==";

@interface FIRAppCheck (Tests) <FIRAppCheckInterop, GACAppCheckTokenDelegate>
- (instancetype)initWithAppName:(NSString *)appName
                   appCheckCore:(GACAppCheck *)appCheckCore
               appCheckProvider:(id<FIRAppCheckProvider>)appCheckProvider
             notificationCenter:(NSNotificationCenter *)notificationCenter
                       settings:(FIRAppCheckSettings *)settings;

- (nullable instancetype)initWithApp:(FIRApp *)app;

- (void)tokenDidUpdate:(nonnull GACAppCheckToken *)token
           serviceName:(nonnull NSString *)serviceName;

@end

@interface FIRAppCheckTests : XCTestCase

@property(nonatomic) NSString *appName;
@property(nonatomic) OCMockObject<FIRAppCheckProvider> *mockAppCheckProvider;
@property(nonatomic) id mockSettings;
@property(nonatomic) NSNotificationCenter *notificationCenter;
@property(nonatomic) id mockAppCheckCore;
@property(nonatomic) FIRAppCheck<FIRAppCheckInterop> *appCheck;

@end

@implementation FIRAppCheckTests

- (void)setUp {
  [super setUp];

  self.appName = @"FIRAppCheckTests";
  self.mockAppCheckProvider = OCMStrictProtocolMock(@protocol(FIRAppCheckProvider));
  self.mockSettings = OCMStrictClassMock([FIRAppCheckSettings class]);
  self.notificationCenter = [[NSNotificationCenter alloc] init];

  self.mockAppCheckCore = OCMStrictClassMock([GACAppCheck class]);

  self.appCheck = [[FIRAppCheck alloc] initWithAppName:self.appName
                                          appCheckCore:self.mockAppCheckCore
                                      appCheckProvider:self.mockAppCheckProvider
                                    notificationCenter:self.notificationCenter
                                              settings:self.mockSettings];
}

- (void)tearDown {
  self.appCheck = nil;
  [self.mockAppCheckCore stopMocking];
  self.mockAppCheckProvider = nil;
  [self.mockAppCheckProvider stopMocking];
  self.mockAppCheckProvider = nil;

  [super tearDown];
}

- (void)testInitWithApp {
  NSString *projectID = @"testInitWithApp_projectID";
  NSString *googleAppID = @"testInitWithApp_googleAppID";
  NSString *appName = @"testInitWithApp_appName";
  NSString *appGroupID = @"testInitWithApp_appGroupID";

  // 1. Stub FIRApp and validate usage.
  id mockApp = OCMStrictClassMock([FIRApp class]);
  id mockAppOptions = OCMStrictClassMock([FIROptions class]);
  OCMStub([mockApp name]).andReturn(appName);
  OCMStub([mockApp isDataCollectionDefaultEnabled]).andReturn(YES);
  OCMStub([(FIRApp *)mockApp options]).andReturn(mockAppOptions);
  OCMExpect([mockAppOptions projectID]).andReturn(projectID);
  OCMExpect([mockAppOptions googleAppID]).andReturn(googleAppID);
  OCMExpect([mockAppOptions appGroupID]).andReturn(appGroupID);

  // 2. Stub attestation provider.
  OCMockObject<FIRAppCheckProviderFactory> *mockProviderFactory =
      OCMStrictProtocolMock(@protocol(FIRAppCheckProviderFactory));
  OCMockObject<FIRAppCheckProvider> *mockProvider =
      OCMStrictProtocolMock(@protocol(FIRAppCheckProvider));
  OCMExpect([mockProviderFactory createProviderWithApp:mockApp]).andReturn(mockProvider);

  [FIRAppCheck setAppCheckProviderFactory:mockProviderFactory];

  // 3. Call init.
  FIRAppCheck *appCheck = [[FIRAppCheck alloc] initWithApp:mockApp];
  XCTAssert([appCheck isKindOfClass:[FIRAppCheck class]]);

  // 4. Verify mocks.
  OCMVerifyAll(mockApp);
  OCMVerifyAll(mockAppOptions);
  OCMVerifyAll(mockProviderFactory);
  OCMVerifyAll(mockProvider);

  // 5. Stop mocking real class mocks.
  [mockApp stopMocking];
  mockApp = nil;
  [mockAppOptions stopMocking];
  mockAppOptions = nil;
}

- (void)testAppCheckDefaultInstance {
  // Should throw an exception when the default app is not configured.
  XCTAssertThrows([FIRAppCheck appCheck]);

  // Configure default FIRApp.
  FIROptions *options =
      [[FIROptions alloc] initWithGoogleAppID:@"1:100000000000:ios:aaaaaaaaaaaaaaaaaaaaaaaa"
                                  GCMSenderID:@"sender_id"];
  options.APIKey = @"api_key";
  options.projectID = @"project_id";
  [FIRApp configureWithOptions:options];

  // Check.
  XCTAssertNotNil([FIRAppCheck appCheck]);

  [FIRApp resetApps];
}

- (void)testAppCheckInstanceForApp {
  FIROptions *options =
      [[FIROptions alloc] initWithGoogleAppID:@"1:100000000000:ios:aaaaaaaaaaaaaaaaaaaaaaaa"
                                  GCMSenderID:@"sender_id"];
  options.APIKey = @"api_key";
  options.projectID = @"project_id";

  [FIRApp configureWithName:@"testAppCheckInstanceForApp" options:options];
  FIRApp *app = [FIRApp appNamed:@"testAppCheckInstanceForApp"];
  XCTAssertNotNil(app);

  XCTAssertNotNil([FIRAppCheck appCheckWithApp:app]);

  [FIRApp resetApps];
}

#pragma mark - Public Get Token

- (void)testGetToken_Success {
  // 1. Create expected token and configure expectations.
  FIRAppCheckToken *expectedToken = [self validToken];

  NSArray * /*[tokenNotification, getToken]*/ expectations =
      [self configuredExpectations_TokenForcingRefresh_withExpectedToken:expectedToken];

  // 2. Request token and verify result.
  [self.appCheck
      tokenForcingRefresh:NO
               completion:^(FIRAppCheckToken *_Nullable token, NSError *_Nullable error) {
                 [expectations.lastObject fulfill];
                 XCTAssertNotNil(token);
                 XCTAssertEqualObjects(token.token, expectedToken.token);
                 XCTAssertNil(error);
               }];

  // 3. Wait for expectations and validate mocks.
  [self waitForExpectations:expectations timeout:0.5];
  [self verifyAllMocks];
}

- (void)testGetToken_AppCheckProviderError {
  // 1. Create expected token and error and configure expectations.
  FIRAppCheckToken *cachedToken = [self soonExpiringToken];
  NSError *providerError = [NSError errorWithDomain:@"FIRAppCheckTests" code:-1 userInfo:nil];

  NSArray * /*[tokenNotification, getToken]*/ expectations =
      [self configuredExpectations_GetTokenWhenError_withError:providerError andToken:cachedToken];

  // 2. Request token and verify result.
  [self.appCheck
      tokenForcingRefresh:NO
               completion:^(FIRAppCheckToken *_Nullable token, NSError *_Nullable error) {
                 [expectations.lastObject fulfill];
                 XCTAssertNil(token);
                 XCTAssertNotNil(error);
                 XCTAssertNotEqualObjects(error, providerError);
                 XCTAssertEqualObjects(error.domain, FIRAppCheckErrorDomain);
                 XCTAssertEqualObjects(error.userInfo[NSUnderlyingErrorKey], providerError);
               }];

  // 3. Wait for expectations and validate mocks.
  [self waitForExpectations:expectations timeout:0.5];
  [self verifyAllMocks];
}

- (void)testGetToken_ServerUnreachableError {
  // 1. Create expected error and configure expectations.
  NSError *serverError = [FIRAppCheckErrorUtil APIErrorWithNetworkError:[self internalError]];

  NSArray * /*[tokenNotification, getToken]*/ expectations =
      [self configuredExpectations_GetTokenWhenError_withError:serverError andToken:nil];

  // 2. Request token and verify result.
  [self.appCheck
      tokenForcingRefresh:NO
               completion:^(FIRAppCheckToken *_Nullable token, NSError *_Nullable error) {
                 [expectations.lastObject fulfill];
                 XCTAssertNil(token);
                 XCTAssertNotNil(error);
                 XCTAssertEqualObjects(error, serverError);
                 XCTAssertEqualObjects(error.domain, FIRAppCheckErrorDomain);
               }];

  // 3. Wait for expectations and validate mocks.
  [self waitForExpectations:expectations timeout:0.5];
  [self verifyAllMocks];
}

- (void)testGetToken_UnsupportedError {
  // 1. Create expected error and configure expectations.
  NSError *providerError =
      [FIRAppCheckErrorUtil unsupportedAttestationProvider:@"AppAttestProvider"];

  NSArray * /*[tokenNotification, getToken]*/ expectations =
      [self configuredExpectations_GetTokenWhenError_withError:providerError andToken:nil];

  // 2. Request token and verify result.
  [self.appCheck
      tokenForcingRefresh:NO
               completion:^(FIRAppCheckToken *_Nullable token, NSError *_Nullable error) {
                 [expectations.lastObject fulfill];
                 XCTAssertNil(token);
                 XCTAssertNotNil(error);
                 XCTAssertEqualObjects(error, providerError);
                 XCTAssertEqualObjects(error.domain, FIRAppCheckErrorDomain);
               }];

  // 3. Wait for expectations and validate mocks.
  [self waitForExpectations:expectations timeout:0.5];
  [self verifyAllMocks];
}

#pragma mark - FIRAppCheckInterop Get Token

- (void)testInteropGetTokenForcingRefresh_Success {
  // 1. Create expected token and configure expectations.
  FIRAppCheckToken *expectedToken = [self validToken];

  NSArray * /*[tokenNotification, getToken]*/ expectations =
      [self configuredExpectations_TokenForcingRefresh_withExpectedToken:expectedToken];

  // 2. Request token and verify result.
  [self.appCheck getTokenForcingRefresh:NO
                             completion:^(id<FIRAppCheckTokenResultInterop> tokenResult) {
                               [expectations.lastObject fulfill];
                               XCTAssertNotNil(tokenResult);
                               XCTAssertEqualObjects(tokenResult.token, expectedToken.token);
                               XCTAssertNil(tokenResult.error);
                             }];

  // 3. Wait for expectations and validate mocks.
  [self waitForExpectations:expectations timeout:0.5];
  [self verifyAllMocks];
}

- (void)testInteropGetTokenForcingRefresh_AppCheckProviderError {
  // 1. Create expected tokens and errors and configure expectations.
  FIRAppCheckToken *cachedToken = [self soonExpiringToken];
  NSError *providerError = [NSError errorWithDomain:@"FIRAppCheckTests" code:-1 userInfo:nil];

  NSArray * /*[tokenNotification, getToken]*/ expectations =
      [self configuredExpectations_GetTokenWhenError_withError:providerError andToken:cachedToken];

  // 2. Request token and verify result.
  [self.appCheck
      getTokenForcingRefresh:NO
                  completion:^(id<FIRAppCheckTokenResultInterop> result) {
                    [expectations.lastObject fulfill];
                    XCTAssertNotNil(result);
                    XCTAssertEqualObjects(result.token, kDummyToken);
                    XCTAssertEqualObjects(result.error, providerError);
                    // Interop API does not wrap errors in public domain.
                    XCTAssertNotEqualObjects(result.error.domain, FIRAppCheckErrorDomain);
                  }];

  // 3. Wait for expectations and validate mocks.
  [self waitForExpectations:expectations timeout:0.5];
  [self verifyAllMocks];
}

- (void)testLimitedUseTokenWithSuccess {
  // 1. Expect token requested from app check provider.
  FIRAppCheckToken *expectedToken = [self validToken];
  //  id completionArg = [OCMArg invokeBlockWithArgs:expectedToken, [NSNull null], nil];
  //  OCMExpect([self.mockAppCheckProvider getTokenWithCompletion:completionArg]);

  GACAppCheckToken *expectedInternalToken = [expectedToken internalToken];
  id completionArg2 = [OCMArg invokeBlockWithArgs:expectedInternalToken, [NSNull null], nil];
  OCMStub([self.mockAppCheckCore limitedUseTokenWithCompletion:completionArg2]);

  // 2. Don't expect token update notification to be sent.
  XCTestExpectation *notificationExpectation = [self tokenUpdateNotificationNotPosted];
  // 3. Expect token request to be completed.
  XCTestExpectation *getTokenExpectation = [self expectationWithDescription:@"getToken"];

  [self.appCheck
      limitedUseTokenWithCompletion:^(FIRAppCheckToken *_Nullable token, NSError *_Nullable error) {
        [getTokenExpectation fulfill];
        XCTAssertNotNil(token);
        XCTAssertEqualObjects(token.token, expectedToken.token);
        XCTAssertNil(error);
      }];
  [self waitForExpectations:@[ notificationExpectation, getTokenExpectation ] timeout:0.5];
  [self verifyAllMocks];
}

- (void)testLimitedUseToken_WhenTokenGenerationErrors {
  // 1. Expect error when requesting token from app check provider.
  NSError *providerError = [FIRAppCheckErrorUtil keychainErrorWithError:[self internalError]];
  //  id completionArg = [OCMArg invokeBlockWithArgs:[NSNull null], providerError, nil];
  //  OCMExpect([self.mockAppCheckProvider getTokenWithCompletion:completionArg]);

  id completionArg2 = [OCMArg invokeBlockWithArgs:[NSNull null], providerError, nil];
  OCMStub([self.mockAppCheckCore limitedUseTokenWithCompletion:completionArg2]);

  // 2. Don't expect token requested from app check provider.
  OCMReject([self.mockAppCheckProvider getTokenWithCompletion:[OCMArg any]]);

  // 3. Don't expect token update notification to be sent.
  XCTestExpectation *notificationExpectation = [self tokenUpdateNotificationNotPosted];
  // 4. Expect token request to be completed.
  XCTestExpectation *getTokenExpectation = [self expectationWithDescription:@"getToken"];

  [self.appCheck
      limitedUseTokenWithCompletion:^(FIRAppCheckToken *_Nullable token, NSError *_Nullable error) {
        [getTokenExpectation fulfill];
        XCTAssertNotNil(error);
        XCTAssertNil(token.token);
        XCTAssertEqualObjects(error, providerError);
        XCTAssertEqualObjects(error.domain, FIRAppCheckErrorDomain);
      }];

  [self waitForExpectations:@[ notificationExpectation, getTokenExpectation ] timeout:0.5];
  [self verifyAllMocks];
}

#pragma mark - Token update notifications

- (void)testTokenUpdateNotificationKeys {
  XCTAssertEqualObjects([self.appCheck tokenDidChangeNotificationName],
                        @"FIRAppCheckAppCheckTokenDidChangeNotification");
  XCTAssertEqualObjects([self.appCheck notificationAppNameKey],
                        @"FIRAppCheckAppNameNotificationKey");
  XCTAssertEqualObjects([self.appCheck notificationTokenKey], @"FIRAppCheckTokenNotificationKey");
}

#pragma mark - Auto-refresh enabled

- (void)testIsTokenAutoRefreshEnabled {
  // Expect value from settings to be used.
  [[[self.mockSettings expect] andReturnValue:@(NO)] isTokenAutoRefreshEnabled];
  XCTAssertFalse(self.appCheck.isTokenAutoRefreshEnabled);

  [[[self.mockSettings expect] andReturnValue:@(YES)] isTokenAutoRefreshEnabled];
  XCTAssertTrue(self.appCheck.isTokenAutoRefreshEnabled);

  OCMVerifyAll(self.mockSettings);
}

- (void)testSetIsTokenAutoRefreshEnabled {
  OCMExpect([self.mockSettings setIsTokenAutoRefreshEnabled:YES]);
  self.appCheck.isTokenAutoRefreshEnabled = YES;

  OCMExpect([self.mockSettings setIsTokenAutoRefreshEnabled:NO]);
  self.appCheck.isTokenAutoRefreshEnabled = NO;

  OCMVerifyAll(self.mockSettings);
}

#pragma mark - Helpers

- (NSError *)internalError {
  return [NSError errorWithDomain:@"com.internal.error" code:-1 userInfo:nil];
}

- (FIRAppCheckToken *)validToken {
  return [[FIRAppCheckToken alloc] initWithToken:[NSUUID UUID].UUIDString
                                  expirationDate:[NSDate distantFuture]];
}

- (FIRAppCheckToken *)soonExpiringToken {
  NSDate *soonExpiringTokenDate = [NSDate dateWithTimeIntervalSinceNow:4.5 * 60];
  return [[FIRAppCheckToken alloc] initWithToken:@"valid" expirationDate:soonExpiringTokenDate];
}

- (XCTestExpectation *)tokenUpdateNotificationWithExpectedToken:(NSString *)expectedToken {
  XCTestExpectation *expectation =
      [self expectationForNotification:[self.appCheck tokenDidChangeNotificationName]
                                object:nil
                    notificationCenter:self.notificationCenter
                               handler:^BOOL(NSNotification *_Nonnull notification) {
                                 XCTAssertEqualObjects(
                                     notification.userInfo[[self.appCheck notificationAppNameKey]],
                                     self.appName);
                                 XCTAssertEqualObjects(
                                     notification.userInfo[[self.appCheck notificationTokenKey]],
                                     expectedToken);
                                 XCTAssertEqualObjects(notification.object, self.appCheck);
                                 return YES;
                               }];
  return expectation;
}

- (XCTestExpectation *)tokenUpdateNotificationNotPosted {
  XCTNSNotificationExpectation *expectation = [[XCTNSNotificationExpectation alloc]
            initWithName:[self.appCheck tokenDidChangeNotificationName]
                  object:nil
      notificationCenter:self.notificationCenter];
  expectation.inverted = YES;
  return expectation;
}

- (NSArray<XCTestExpectation *> *)configuredExpectations_TokenForcingRefresh_withExpectedToken:
    (FIRAppCheckToken *)expectedToken {
  // 1. Expect token requested from app check core.
  GACAppCheckToken *expectedInternalToken = [expectedToken internalToken];
  id completionArg = [OCMArg invokeBlockWithArgs:expectedInternalToken, [NSNull null], nil];
  OCMExpect([self.mockAppCheckCore tokenForcingRefresh:NO completion:completionArg])
      .andDo(^(NSInvocation *invocation) {
        [self.appCheck tokenDidUpdate:expectedInternalToken serviceName:self.appName];
      })
      .ignoringNonObjectArgs();

  // 2. Expect token update notification to be sent.
  XCTestExpectation *tokenNotificationExpectation =
      [self tokenUpdateNotificationWithExpectedToken:expectedToken.token];

  // 3. Expect token request to be completed.
  XCTestExpectation *getTokenExpectation = [self expectationWithDescription:@"getToken"];

  return @[ tokenNotificationExpectation, getTokenExpectation ];
}

- (NSArray<XCTestExpectation *> *)
    configuredExpectations_GetTokenWhenError_withError:(NSError *_Nonnull)error
                                              andToken:(FIRAppCheckToken *_Nullable)token {
  // 1. Expect token requested from app check core.
  id completionArg = [OCMArg invokeBlockWithArgs:[NSNull null], error, nil];
  OCMExpect([self.mockAppCheckCore tokenForcingRefresh:NO completion:completionArg])
      .ignoringNonObjectArgs();

  // 2. Don't expect token requested from app check provider.
  OCMReject([self.mockAppCheckProvider getTokenWithCompletion:[OCMArg any]]);

  // 3. Expect token update notification to be sent.
  XCTestExpectation *notificationExpectation = [self tokenUpdateNotificationNotPosted];

  // 4. Expect token request to be completed.
  XCTestExpectation *getTokenExpectation = [self expectationWithDescription:@"getToken"];

  return @[ notificationExpectation, getTokenExpectation ];
}

- (void)verifyAllMocks {
  OCMVerifyAll(self.mockAppCheckProvider);
  OCMVerifyAll(self.mockSettings);
  OCMVerifyAll(self.mockAppCheckCore);
}

@end

#endif  // FIR_DEVICE_CHECK_SUPPORTED_TARGETS
