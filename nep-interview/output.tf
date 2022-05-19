output "user-passwords" {
    value = module.sftp.passwords
    sensitive = true 
}