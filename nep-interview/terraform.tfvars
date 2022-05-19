name = "nep-interview-sftp" 
users = {
    user1 = {
        HomeDirectory = "/nep-interview-user1-bucket/" 
        PublicKey = "ssh-rsa YOUR_SSH_PUBLIC_KEY" 
        AllowFrom = [ "8.8.8.8/32" ]
        # Tags = { 
        #     Name = "Test user1"
        #     Organisation = "NEP" 
        # }
    }
    user2 = {
        HomeDirectory = "/nep-interview-shared-bucket/"
    }
    user3 = {
        HomeDirectory = "/nep-interview-shared-bucket/"
        ReadOnly = true
    }
}