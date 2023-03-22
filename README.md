# Terraform Cloud入门指南示例

这是一个Terraform配置的例子，用于[Terraform Cloud入门指南](https://learn.hashicorp.com/terraform/cloud-gettingstarted/tfc_overview)。

## 这将做什么？

这是一个Terraform配置，将在你的AWS账户中创建一个EC2实例。

当你在Terraform Cloud上建立一个工作空间时，你可以链接到这个资源库。然后，Terraform云可以在变化被推送时自动运行`terraform plan`和`terraform apply`。关于Terraform Cloud如何与版本控制系统互动的更多信息，请参阅[我们的VCS文档](https://www.terraform.io/docs/cloud/run/ui.html)。

## 有哪些先决条件？

你必须有一个AWS账户，并向Terraform Cloud提供你的AWS Access Key ID和AWS Secret Access Key。Terraform Cloud使用[Vault](https://www.vaultproject.io/)对变量进行加密和存储。关于如何在Terraform Cloud中存储变量的更多信息，请参阅[我们的变量文档](https://www.terraform.io/docs/cloud/workspaces/variables.html)。

`AWS_ACCESS_KEY_ID`和`AWS_SECRET_ACCESS_KEY`的值应该作为环境变量保存在工作区。
