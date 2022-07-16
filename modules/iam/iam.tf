resource "aws_iam_user" "this" {
  name = "tf-${var.environment}-ci-user"
}

resource "aws_iam_role" "this" {
    name                  = "tf-${var.environment}-ci-role"
    assume_role_policy    = jsonencode(
      {
        Version   = "2012-10-17"
        Statement = [
          {
            Action    = "sts:AssumeRole"
            Condition = {}
            Effect    = "Allow"
            Principal = {
              AWS = "arn:aws:iam::${var.aws_account}:root"
            }
          },
        ]
      }
  )
}

resource "aws_iam_group" "this" {
  name = "tf-${var.environment}-ci-group"
}


resource "aws_iam_policy" "this" {
  name = "tf-${var.environment}-ci-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "terraform0"
        Resource = aws_iam_role.this.arn
      },
      {
        Action = "sts:GetCallerIdentity"
        Effect = "Allow"
        Sid    = "terraform1"
        Resource = "*"
      }      
    ]
  })
}

resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_group_membership" "this" {
  name = "tf-${var.environment}-ci-membership"
  group = aws_iam_group.this.name
  users = [
    aws_iam_user.this.name,
  ]
}