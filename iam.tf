resource "aws_iam_role" "eks_role" {
  name = "EKSServiceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "eks.amazonaws.com",
            "ec2.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "eks_policy_attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    
  ])

  name       = "eks-${replace(each.value, "arn:aws:iam::aws:policy/", "")}"
  roles      = [aws_iam_role.eks_role.name]
  policy_arn = each.value
}

resource "aws_iam_role" "jenkins_role" {
  name = "JenkinsServiceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "jenkins_policy_attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
  ])

  name       = "jenkins-${replace(each.value, "arn:aws:iam::aws:policy/", "")}"
  roles      = [aws_iam_role.jenkins_role.name]
  policy_arn = each.value
}
