//
// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "MSIDBrokerOperationGetSsoCookiesResponse.h"
#import "MSIDPrtHeader.h"
#import "MSIDDeviceHeader.h"
#import "MSIDJsonSerializableFactory.h"
#import "MSIDJsonSerializableTypes.h"
#import "MSIDJsonSerializer.h"
#import "NSString+MSIDExtensions.h"
#import "NSDictionary+MSIDExtensions.h"

static NSString *const MSID_PRT_HEADERS = @"prt_headers";
static NSString *const MSID_DEVICE_HEADERS = @"device_headers";

@implementation MSIDBrokerOperationGetSsoCookiesResponse

+ (void)load
{
    [MSIDJsonSerializableFactory registerClass:self forClassType:self.responseType];
}

+ (NSString *)responseType
{
    return MSID_JSON_TYPE_BROKER_OPERATION_GET_SSO_COOKIES_RESPONSE;
}

#pragma mark - MSIDJsonSerializable

- (instancetype)initWithJSONDictionary:(NSDictionary *)json error:(NSError **)error
{
    self = [super initWithJSONDictionary:json error:error];
    
    if (self)
    {
        if (![json msidAssertType:NSString.class ofKey:@"sso_cookies" required:NO error:error])
        {
            return nil;
        }
        
        NSString *ssoCookiesString = json[@"sso_cookies"];
        
        if ([NSString msidIsStringNilOrBlank:ssoCookiesString])
        {
            self.prtHeaders = nil;
            self.deviceHeaders = nil;
            self.success = YES;
            return self;
        }
        
        NSDictionary *ssoCookiesJson = [ssoCookiesString msidJson];
        
        _prtHeaders = (NSArray<MSIDPrtHeader *> *)[self convertToCredentialHeaderObjectFrom:ssoCookiesJson credentialName:MSID_PRT_HEADERS error:error];
        
        _deviceHeaders = (NSArray<MSIDDeviceHeader *> *)[self convertToCredentialHeaderObjectFrom:ssoCookiesJson credentialName:MSID_DEVICE_HEADERS error:error];
    }
    
    return self;
}

- (NSDictionary *)jsonDictionary
{
    NSMutableDictionary *json = [[super jsonDictionary] mutableCopy];
    if (!json) return nil;
    
    NSMutableDictionary *cookiesJson = [NSMutableDictionary new];
    cookiesJson[MSID_PRT_HEADERS] = [self convertToJsonFrom:self.prtHeaders];
    cookiesJson[MSID_DEVICE_HEADERS] = [self convertToJsonFrom:self.deviceHeaders];
    json[@"sso_cookies"] = [cookiesJson msidJSONSerializeWithContext:nil];
    return json;
}

#pragma mark - helpers

- (NSMutableArray *)convertToJsonFrom:(NSArray<MSIDCredentialHeader *> *)credentialHeaders
{
    NSMutableArray *headersJson = [NSMutableArray new];
    for (MSIDCredentialHeader *credentialHeader in credentialHeaders)
    {
        [headersJson addObject:[credentialHeader jsonDictionary]];
    }
    
    return headersJson.count > 0 ? headersJson : nil;
}

- (nullable NSArray<MSIDCredentialHeader*> *)convertToCredentialHeaderObjectFrom:(NSDictionary *)json credentialName:(NSString *)name error:(NSError **)error
{
    if(!json[name]) return nil;

    if (json[name] && ![json[name] isKindOfClass:NSArray.class])
    {
        if (error)
        {
            *error = MSIDCreateError(MSIDErrorDomain, MSIDErrorInternal, @"%@ is not an array", name, nil, nil, nil, nil, YES);
        }
        
        return nil;
    }
    
    NSMutableArray<MSIDCredentialHeader*> *headers = [NSMutableArray new];
    for (NSDictionary *headerBlob in (NSArray *)json[name])
    {
        MSIDCredentialHeader *header = nil;
        if ([name isEqualToString:MSID_PRT_HEADERS])
        {
            header = [[MSIDPrtHeader alloc] initWithJSONDictionary:headerBlob error:error];
        }
        else if ([name isEqualToString:MSID_DEVICE_HEADERS])
        {
            header = [[MSIDDeviceHeader alloc] initWithJSONDictionary:headerBlob error:error];
        }
        else
        {
            MSID_LOG_WITH_CTX(MSIDLogLevelInfo, nil, @"Unknown type of credential header");
        }
        
        // Process is terminated when a header is errored out for this type
        if (!header) return nil;
        
        [headers addObject:header];
    }
    
    // Empty headers is a valid case
    return headers.count > 0 ? headers : nil;
}

@end
