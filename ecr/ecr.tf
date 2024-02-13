module "ecr" {
  source       = "cloudposse/ecr/aws"
  version      = "0.36.0"
  name         = "wsgi-${var.project_name}-${var.environment}-repository"
  force_delete = true
}

resource "null_resource" "build_and_push_image" {
  provisioner "local-exec" {
    command = "bash ${path.module}/build.sh"
    environment = {
      ECR_REPO_URI = module.ecr.repository_url
      AWS_REGION   = var.aws_region
    }
  }

  triggers = {
    image_pushed = sha1(file("${path.module}/build.sh"))
  }

  depends_on = [module.ecr]
}
