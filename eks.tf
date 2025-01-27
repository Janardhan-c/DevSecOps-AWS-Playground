resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids             = aws_subnet.public_subnets[*].id  # Ensure these subnets are public
    endpoint_public_access = true  # Allows access to the Kubernetes API publicly
    endpoint_private_access = false  # No private endpoint
  }
}
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "my-node-group"
  node_role_arn       = aws_iam_role.eks_role.arn
  subnet_ids      = aws_subnet.public_subnets[*].id
  instance_types  = ["t3.medium"]
  
  

  scaling_config {
    desired_size = 2
    min_size = 1
    max_size = 3
  }
}