module "sftp" {
    source = "../terraform/modules/sftp"
    name = var.name
    users = var.users
}