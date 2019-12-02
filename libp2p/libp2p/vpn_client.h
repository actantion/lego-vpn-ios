#pragma once

#include <vector>
#include <memory>
#include <string>
#include <cstdint>
#include <mutex>
#include <unordered_map>
#include <unordered_set>
#include <map>
#include <set>
#include <deque>

namespace lego {

namespace transport {
    class Transport;
    typedef std::shared_ptr<Transport> TransportPtr;
    namespace protobuf {
        class Header;
    }
}  // namespace transport

namespace common {
    class Tick;
}

namespace dht {
    class Node;
    typedef std::shared_ptr<Node> NodePtr;
    class BaseDht;
    typedef std::shared_ptr<BaseDht> BaseDhtPtr;
}  // namespace dht

namespace client {

namespace protobuf {
    class Block;
    class BlockMessage;
    typedef std::shared_ptr<Block> BlockPtr;
    class AccountHeightResponse;
    class GetTxBlockResponse;
    class GetVpnInfoResponse;
}  // namespace protobuf

struct VpnServerNode {
    VpnServerNode(
            const std::string& in_ip,
            uint16_t s_port,
            uint16_t r_port,
            const std::string& skey,
            const std::string& dkey,
            const std::string& pkey,
            const std::string& id,
            bool new_node)
            : ip(in_ip),
              svr_port(s_port),
              route_port(r_port),
              seckey(skey),
              dht_key(dkey),
              pubkey(pkey),
              acccount_id(id),
              new_get(new_node) {
        timeout = std::chrono::steady_clock::now() + std::chrono::seconds(3600);
    }
    std::string ip;
    uint16_t svr_port;
    uint16_t route_port;
    std::string seckey;
    std::string dht_key;
    std::string pubkey;
    std::string acccount_id;
    bool new_get{ false };
    std::chrono::steady_clock::time_point timeout;
};
typedef std::shared_ptr<VpnServerNode> VpnServerNodePtr;

struct TxInfo {
    TxInfo(
            const std::string& in_to,
            uint64_t in_balance,
            uint32_t h,
            const std::string& hash,
            const protobuf::BlockPtr& in_block)
            : to(in_to), balance(in_balance), height(h),
              block_hash(hash), block_ptr(in_block) {}
    std::string to;
    uint64_t balance;
    uint32_t height;
    std::string block_hash;
    protobuf::BlockPtr block_ptr;
};
typedef std::shared_ptr<TxInfo> TxInfoPtr;

struct LastPaiedVipInfo {
    uint64_t height;
    uint64_t timestamp;
    std::string to_account;
    uint64_t amount;
    std::string block_hash;
};
typedef std::shared_ptr<LastPaiedVipInfo> LastPaiedVipInfoPtr;

class VpnClient {
public:
    static VpnClient* Instance();
    std::string Init(
            const std::string& local_ip,
            uint16_t local_port,
            const std::string& bootstrap,
            const std::string& path,
            const std::string& version,
            const std::string& private_key);
    std::string GetVpnServerNodes(
            const std::string& country,
            uint32_t count,
            bool route,
            std::vector<VpnServerNodePtr>& nodes);
    std::string Transaction(const std::string& to, uint64_t amount, std::string& tx_gid);
    protobuf::BlockPtr GetBlockWithGid(const std::string& gid);
    protobuf::BlockPtr GetBlockWithHash(const std::string& block_hash);
    int GetSocket();
    bool ConfigExists(const std::string& conf_path);
    bool IsFirstInstall() {
        return first_install_;
    }
    bool SetFirstInstall();
    std::string Transactions(uint32_t begin, uint32_t len);
    int64_t GetBalance();
    void VpnHeartbeat(const std::string& dht_key);
    int ResetTransport(const std::string& ip, uint16_t port);
    std::string GetPublicKey();
    std::string GetSecretKey(const std::string& peer_pubkey);
    std::string GetRouting(const std::string& start, const std::string& end);
    int VpnLogin(
            const std::string& svr_account,
            const std::vector<std::string>& route_vec,
            std::string& login_gid);
    int VpnLogout();
    std::string CheckVersion();
    std::string PayForVPN(const std::string& to, const std::string& gid, uint64_t amount);
    std::string CheckVip();
    std::string CheckFreeBandwidth();
    void Destroy();
    std::string ResetPrivateKey(const std::string& prikey);
    std::string GetClientProperty();

private:
    VpnClient();
    ~VpnClient();

    void HandleMessage(transport::protobuf::Header& header);
    void HandleBlockMessage(transport::protobuf::Header& header);
    void HandleServiceMessage(transport::protobuf::Header& header);
    void HandleContractMessage(transport::protobuf::Header& header);
    int InitTransport();
    int SetPriAndPubKey(const std::string& prikey);
    int InitNetworkSingleton();
    void GetVpnNodes();
    int CreateClientUniversalNetwork();
    void CheckTxExists();
    void WriteDefaultLogConf(
            const std::string& log_conf_path,
            const std::string& log_path);
    void GetAccountHeight();
    void GetAccountBlockWithHeight();
    void HandleHeightResponse(const protobuf::AccountHeightResponse& height_res);
    void HandleBlockResponse(const protobuf::GetTxBlockResponse& block_res);
    void HandleGetVpnResponse(
            const protobuf::GetVpnInfoResponse& vpn_res,
            const std::string& dht_key);
    void DumpNodeToConfig();
    void DumpVpnNodes();
    void DumpRouteNodes();
    void ReadVpnNodesFromConf();
    void ReadRouteNodesFromConf();
    void DumpBootstrapNodes();
    void GetNetworkNodes(const std::vector<std::string>& country_vec, uint32_t network_id);
    void InitRouteAndVpnServer();
    void GetVpnVersion();
    int SetDefaultRouting();
    std::string GetDefaultRouting();
    void SendGetAccountAttrLastBlock(
            const std::string& attr,
            const std::string& account,
            uint64_t height);
    void HandleCheckVipResponse(
            transport::protobuf::Header& header,
            client::protobuf::BlockMessage& block_msg);
    void SendGetBlockWithGid(const std::string& str, bool is_gid);
    void SendGetAccountAttrUsedBandwidth();

    static const uint32_t kDefaultUdpSendBufferSize = 2u * 1024u * 1024u;
    static const uint32_t kDefaultUdpRecvBufferSize = 2u * 1024u * 1024u;
    static const uint32_t kTestCreateAccountPeriod = 100u * 1000u;
    static const int64_t kTestNewElectPeriod = 10ll * 1000ll * 1000ll;
    static const uint32_t kCheckTxPeriod = 1000 * 1000;
    static const uint32_t kGetVpnNodesPeriod = 3 * 1000 * 1000;
    static const uint32_t kHeightMaxSize = 1024u;

    transport::TransportPtr transport_{ nullptr };
    bool inited_{ false };
    std::mutex init_mutex_;
    bool root_dht_joined_{ false };
    bool client_mode_{ true };
    uint32_t send_buff_size_{ kDefaultUdpSendBufferSize };
    uint32_t recv_buff_size_{ kDefaultUdpRecvBufferSize };
    std::unordered_map<std::string, protobuf::BlockPtr> tx_map_;
    std::mutex tx_map_mutex_;
    bool first_install_{ false };
    std::string config_path_;
    std::map<uint64_t, std::string> hight_block_map_;
    std::mutex hight_block_map_mutex_;
    std::set<uint64_t> local_account_height_set_;
    uint64_t vpn_version_last_height_;
    std::string vpn_download_url_;
    std::mutex height_set_mutex_;
    uint32_t check_times_{ 0 };
    std::map<std::string, std::deque<VpnServerNodePtr>> vpn_nodes_map_;
    std::mutex vpn_nodes_map_mutex_;
    std::map<std::string, std::deque<VpnServerNodePtr>> route_nodes_map_;
    std::mutex route_nodes_map_mutex_;
    LastPaiedVipInfoPtr paied_vip_info_[2];
    uint32_t paied_vip_valid_idx_{ 0 };
    int32_t today_used_bandwidth_{ -1 };

    std::shared_ptr<common::Tick> check_tx_tick_{ nullptr };
    std::shared_ptr<common::Tick>  vpn_nodes_tick_{ nullptr };
    std::shared_ptr<common::Tick>  dump_config_tick_{ nullptr };
    std::shared_ptr<common::Tick>  dump_bootstrap_tick_{ nullptr };
    bool account_created_{ false };
    std::set<std::string> vpn_committee_accounts_;
};

}  // namespace client

}  // namespace lego
