//
//  libp2p.m
//  libp2p
//
//  Created by actantion on 2019/9/11.
//  Copyright © 2019 actantion. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <iostream>

#import "libp2p.h"
#include "vpn_client.h"

@implementation LibP2P

NSString* method_ = @"aes-128-cfb";
NSString* choosed_country_ = @"US";
NSString* public_key_ = @"000000000000000000000000000000000";

+(NSString*) getMethod {
    return method_;
}

+(NSString*) getChoosedCountry {
    return choosed_country_;
}

+(UInt32) changeStrIp: (NSString*) ip {
    std::string tmp_ip = std::string([ip UTF8String]);
    struct in_addr s;
    inet_pton(AF_INET, tmp_ip.c_str(), &s);
    return s.s_addr;
}

+ (void) SetPublicKeyEx:(NSString*) pubkey {
    public_key_ = pubkey;
    std::string tmp_bootstarp = std::string([public_key_ UTF8String]);
    std::cout << "set public key: " << tmp_bootstarp << std::endl;
}

+ (NSData *)HexDecode:(NSString *)hexString {
    const char *chars = [hexString UTF8String];
    int i = 0;
    NSUInteger len = hexString.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

+ (NSString *)HexEncode:(NSData *)data {
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    if (!dataBuffer) {
        return [NSString string];
    }
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", (unsigned char)dataBuffer[i]];
    }
    return [NSString stringWithString:hexString];
}

+(void)SayHello {
    NSLog(@"hello framework world.");
}

+(NSString*) InitP2pNetwork:(NSString*) local_ip : (NSInteger)local_port : (NSString*)bootstrap : (NSString*)conf_path : (NSString*)version : (NSString*) pri_key{
    std::string tmp_local_ip = std::string([local_ip UTF8String]);
    uint16_t tmp_local_port = (uint16_t)local_port;
    std::string tmp_bootstarp = std::string([bootstrap UTF8String]);
    std::string tmp_conf_path = std::string([conf_path UTF8String]);
    std::string tmp_version = std::string([version UTF8String]);
    std::string private_key = std::string([pri_key UTF8String]);
    
    std::string res = lego::client::VpnClient::Instance()->Init(tmp_local_ip, tmp_local_port, tmp_bootstarp, tmp_conf_path, tmp_version, private_key);
    if (res == "ERROR") {
        std::cout << "p2p network init res: " << res << std::endl;
        NSString *res_str = [NSString stringWithCString:"" encoding:[NSString defaultCStringEncoding]];
        return res_str;
    }
    
    std::string gid;
    lego::client::VpnClient::Instance()->Transaction("", 0, gid);
    NSString *res_str = [NSString stringWithCString:res.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

+(NSInteger) GetSocketId {
    return lego::client::VpnClient::Instance()->GetSocket();
}

+(NSString*) GetVpnNodes:(NSString*) country: (Boolean) route {
    std::vector<lego::client::VpnServerNodePtr> nodes;
    std::string tmp_country = std::string([country UTF8String]);
    lego::client::VpnClient::Instance()->GetVpnServerNodes(tmp_country, 16, route, nodes);
    std::string vpn_svr = "";
    for (uint32_t i = 0; i < nodes.size(); ++i) {
        vpn_svr += nodes[i]->ip + ":";
        vpn_svr += std::to_string(nodes[i]->svr_port) + ":";
        vpn_svr += std::to_string(nodes[i]->route_port) + ":";
        vpn_svr += nodes[i]->seckey + ":";
        vpn_svr += nodes[i]->pubkey + ":";
        vpn_svr += nodes[i]->dht_key + ":";
        if (i != nodes.size() - 1) {
            vpn_svr += ",";
        }
    }
    NSString *res_str = [NSString stringWithCString:vpn_svr.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

+(NSString*) GetTransactions {
    std::string res = lego::client::VpnClient::Instance()->Transactions(0, 64);
    NSString *res_str = [NSString stringWithCString:res.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

+(UInt64) GetBalance {
    return lego::client::VpnClient::Instance()->GetBalance();
}

+(void) ResetTransport:(NSString*) local_ip: (NSInteger)local_port {
    std::string tmp_local_ip = std::string([local_ip UTF8String]);
    lego::client::VpnClient::Instance()->ResetTransport(tmp_local_ip, local_port);
}

+(NSString*) GetPublicKey {
    std::string res = lego::client::VpnClient::Instance()->GetPublicKey();
    NSString *res_str = [NSString stringWithCString:res.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

+ (NSString *)CheckVersion {
    std::string res = lego::client::VpnClient::Instance()->CheckVersion();
    NSString *res_str = [NSString stringWithCString:res.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

+ (NSString *)PayforVpn: (NSString*)to: (NSString*)gid: (NSInteger)amount {
    std::string to_acc = std::string([to UTF8String]);
    std::string tmp_gid = std::string([gid UTF8String]);
    std::string res = lego::client::VpnClient::Instance()->PayForVPN(to_acc, tmp_gid, amount);
    NSString *res_str = [NSString stringWithCString:res.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

+ (NSString *)CheckVip {
    std::string res = lego::client::VpnClient::Instance()->CheckVip();
    NSString *res_str = [NSString stringWithCString:res.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

+ (NSString *)GetUsedBandwidth {
    std::string res = lego::client::VpnClient::Instance()->CheckFreeBandwidth();
    NSString *res_str = [NSString stringWithCString:res.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

+ (void)Destroy {
    //lego::client::VpnClient::Instance()->Destroy();
}

+ (NSString *)ResetPrivateKey:(NSString *)prikey {
    std::string tmp_prikey = std::string([prikey UTF8String]);
    std::string res = lego::client::VpnClient::Instance()->ResetPrivateKey(tmp_prikey);
    NSString *res_str = [NSString stringWithCString:res.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

@end
