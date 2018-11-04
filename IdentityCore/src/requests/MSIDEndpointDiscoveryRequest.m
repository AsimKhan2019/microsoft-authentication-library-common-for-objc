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

#import "MSIDEndpointDiscoveryRequest.h"
#import "MSIDRequestParameters.h"
#import "MSIDAccountIdentifier.h"
#import "MSIDAuthority.h"

@interface MSIDEndpointDiscoveryRequest()

@property (nonatomic) MSIDRequestParameters *requestParameters;

@end

@implementation MSIDEndpointDiscoveryRequest

- (nullable instancetype)initWithRequestParameters:(nonnull MSIDRequestParameters *)parameters
{
    self = [super init];

    if (self)
    {
        self.requestParameters = parameters;
    }

    return self;
}

/*
- (void)discoverEndpointsWithUsername:(NSString *)displayableId
                           completion:(nonnull MSIDAuthorityCompletion)authorityCompletion
{
    [self.requestParameters.authority resolveAndValidate:self.requestParameters
                                       userPrincipalName:displayableId
                                                 context:nil
                                         completionBlock:^(NSURL * _Nullable openIdConfigurationEndpoint, BOOL validated, NSError * _Nullable error) {


    }];

    [_parameters.unvalidatedAuthority resolveAndValidate:_parameters.validateAuthority
                                       userPrincipalName:upn
                                                 context:_parameters
                                         completionBlock:^(NSURL *openIdConfigurationEndpoint, BOOL validated, NSError *error)
     {
         if (error)
         {
             MSALTelemetryAPIEvent *event = [self getTelemetryAPIEvent];
             [self stopTelemetryEvent:event error:error];

             completionBlock(NO, error);
             return;
         }

         completionBlock(YES, nil);
     }];
}*/

@end
