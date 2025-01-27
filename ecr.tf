resource "aws_ecr_repository" "frontend" {
  name = "frontend-repo"
}

resource "aws_ecr_repository" "backend" {
  name = "backend-repo"
}

resource "aws_ecr_repository" "database" {
  name = "database-repo"
}
output "ecr_repositories" {
  value = {
    frontend = aws_ecr_repository.frontend.repository_url
    backend  = aws_ecr_repository.backend.repository_url
    database = aws_ecr_repository.database.repository_url
  }
}

resource "docker_image" "frontend_image" {
  name         = "${aws_ecr_repository.frontend.repository_url}:latest"
  build {
    context    = "${path.module}/app/frontend"
    dockerfile = "${path.module}/app/frontend/Dockerfile"
  }
}

resource "docker_registry_image" "frontend_push" {
  name = docker_image.frontend_image.name
}

resource "docker_image" "backend_image" {
  name         = "${aws_ecr_repository.backend.repository_url}:latest"
  build {
    context    = "${path.module}/app/backend"
    dockerfile = "${path.module}/app/backend/Dockerfile"
  }
}

resource "docker_registry_image" "backend_push" {
  name = docker_image.backend_image.name
}

resource "docker_image" "database_image" {
  name         = "${aws_ecr_repository.database.repository_url}:latest"
  build {
    context    = "${path.module}/app/database"
    dockerfile = "${path.module}/app/database/Dockerfile"
  }
}

resource "docker_registry_image" "database_push" {
  name = docker_image.database_image.name
}
