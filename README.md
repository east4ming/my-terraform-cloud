# Terraform Cloud 入门指南示例

这是一个 Terraform 配置，在 Oracle 云基础设施上创建了 Always Free 服务。

Terraform 代码用于创建一个资源管理器堆栈，创建所需的资源并在创建的资源上配置应用程序。

## 这将做什么？

这是一个 Terraform 配置，将在你的 OCI 账户中创建一个 Free Tier。

当你在 Terraform Cloud 上建立一个工作空间时，你可以链接到这个资源库。然后，Terraform 云可以在变化被推送时自动运行`terraform plan`和`terraform apply`。关于 Terraform Cloud 如何与版本控制系统互动的更多信息，请参阅 [我们的 VCS 文档](https://www.terraform.io/docs/cloud/run/ui.html)。

## TODO

- [x] 申请 2 台 amd 1C 1G 机器
- [x] Image 改为 Ubuntu 22.04
- [x] 调整安全组, 开放如下端口:
   1. 8080-8090(测试用)
   2. 443
   3. TCP/UDP: 53
   4. TCP: 6443(K8s API)
   5. TCP: 10250(kubectl cAdvisor metrics)
   6. UDP: 51820-51830 (wireguard tailscale)
   7. UDP: 8472(Flannel)
   8. UDP: 41641(tailscale)
   9. UDP: 3478(tailscale)
   10. TCP : 50051? (暂不加)
   11. TCP : 30723? (暂不加)
- [x] 安装 tailscale
- [x] 安装 docker & docker compose
- [x] 安装 nomad
- [x] 安装 k3s
- [ ] 系统参数调优
- [ ] 申请 4 台 arm 1c 6G 机器
   1. 2台挂 100GB 存储
   2. 另外2台不挂外部存储
