//
//  SPTIabConsentStringParser.h
//  SPTProximityKit
//
//  Created by Quentin Beaudouin on 04/06/2020.
//  Copyright © 2020 Alexandre Fortoul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StroeerSDK/SPTIabTCFModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface STSPTIabTCStringParser : NSObject

+ (SPTIabTCFModel *)parseConsentString:(NSString *)consentString
    NS_SWIFT_NAME(parse(consentString:));

@end

NS_ASSUME_NONNULL_END
