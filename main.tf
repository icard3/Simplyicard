resource "aws_ecr_repository" "ecr" {
  name                 = "simplyicard-app"
  image_tag_mutability = "MUTABLE"          # use "IMMUTABLE" for prod

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "simplyicard-app"
    Environment = "simplyicard-app.environment"
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr.name


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
         tagPatternList = ["*"]      # <--- use this!
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



