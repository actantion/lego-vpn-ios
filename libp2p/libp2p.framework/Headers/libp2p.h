//
//  libp2p.h
//  libp2p
//
//  Created by actantion on 2019/9/11.
//  Copyright © 2019 actantion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


//! Project version number for libp2p.
FOUNDATION_EXPORT double libp2pVersionNumber;

//! Project version string for libp2p.
FOUNDATION_EXPORT const unsigned char libp2pVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <libp2p/PublicHeader.h>


@interface LibP2P : NSObject

+(void)SayHello;

+(NSString*) InitP2pNetwork:(NSString*) local_ip: (NSInteger)local_port: (NSString*)bootstrap: (NSString*)conf_path: (NSString*)log_path: (NSString*) log_conf_path;

@end
