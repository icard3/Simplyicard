resource "aws_ecr_repository" "ecr" {
  for_each             = toset(var.repository_names)
  name                 = each.value
  image_tag_mutability = "MUTABLE" # use "IMMUTABLE" for prod

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = each.value
    Environment = "simplyicard-app.environment"
  }

  force_delete = true
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  for_each   = toset(var.repository_names)
  repository = aws_ecr_repository.ecr[each.value].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images after 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep only latest 30 tagged images"
        selection = {
          tagStatus      = "tagged"
          tagPatternList = ["*"] # <--- use this!
          countType      = "imageCountMoreThan"
          countNumber    = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
