resource "aws_secretsmanager_secret" "secret" {
  for_each = var.users
  name = "SFTP/${each.key}"
}

resource "aws_secretsmanager_secret_version" "secrets" {
  for_each      = var.users
  secret_id     = aws_secretsmanager_secret.secret[each.key].id
  secret_string = jsonencode({
    "Password": "${random_password.password[each.key]}", "HomeDirectory" : "/${aws_s3_bucket.s3.id}${each.value["HomeDirectory"]}", "Role" : "${aws_iam_role.sftp_role.arn}"
  })
}

resource "random_password" "password" {
  for_each      = var.users
  length           = 16
  special          = false
}

