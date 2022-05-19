variable "name" {
    default = "nep-interview-sftp" 
}
# variable "tags" {
#     default = {}
# }
variable "users" {
    type = map(object({
        HomeDirectory : string
        PublicKey: optional(string)
        AllowFrom: optional(list(string))
        Tags: optional(object({key = string}))
    }))
    default = {}
}