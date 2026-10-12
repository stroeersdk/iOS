//
//  StroeerSDK.h
//  StroeerSDK
//
//  Created by Marcel Klínek on 05.10.2021.
//

#import <Foundation/Foundation.h>

// Public umbrella for the module:
#import <StroeerSDK/SPTIabTCFConstants.h>
#import <StroeerSDK/SPTIabTCFUtils.h>
#import <StroeerSDK/SPTIabTCFv1Types.h>
#import <StroeerSDK/SPTIabTCFv2Types.h>
#import <StroeerSDK/SPTIabPublisherRestriction.h>
#import <StroeerSDK/SPTIabTCFModel.h>
#import <StroeerSDK/SPTIabTCStringParser.h>
#import <StroeerSDK/SPTIabTCFv1StorageProtocol.h>
#import <StroeerSDK/SPTIabTCFv1StorageUserDefaults.h>
#import <StroeerSDK/SPTIabTCFv2StorageProtocol.h>
#import <StroeerSDK/SPTIabTCFv2StorageUserDefaults.h>
#import <StroeerSDK/SPTIabTCFApi.h>

// GCDWebServer (embedded)
#import <StroeerSDK/GCDWebServerHTTPStatusCodes.h>
#import <StroeerSDK/GCDWebServerFunctions.h>

#import <StroeerSDK/GCDWebServerConnection.h>
#import <StroeerSDK/GCDWebServerRequest.h>
#import <StroeerSDK/GCDWebServerDataRequest.h>
#import <StroeerSDK/GCDWebServerFileRequest.h>
#import <StroeerSDK/GCDWebServerMultiPartFormRequest.h>
#import <StroeerSDK/GCDWebServerURLEncodedFormRequest.h>

#import <StroeerSDK/GCDWebServerResponse.h>
#import <StroeerSDK/GCDWebServerDataResponse.h>
#import <StroeerSDK/GCDWebServerErrorResponse.h>
#import <StroeerSDK/GCDWebServerFileResponse.h>
#import <StroeerSDK/GCDWebServerStreamedResponse.h>

#import <StroeerSDK/GCDWebServer.h>

//! Project version number for StroeerSDK.
FOUNDATION_EXPORT double StroeerSDKVersionNumber;

//! Project version string for StroeerSDK.
FOUNDATION_EXPORT const unsigned char StroeerSDKVersionString[];
