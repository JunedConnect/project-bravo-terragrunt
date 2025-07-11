resource "aws_eks_cluster" "this" {
  name = var.name

  access_config {
    authentication_mode                         = var.authentication-mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap-cluster-creator-admin-permissions
  }

  role_arn = aws_iam_role.eks-cluster-role.arn
  version  = var.cluster-version

  vpc_config {
    subnet_ids = [
      var.public-subnet-1-id,
      var.public-subnet-2-id,
      var.private-subnet-1-id,
      var.private-subnet-2-id
    ]

    endpoint_private_access = var.endpoint-private-access
    endpoint_public_access  = var.endpoint-public-access

  }

  upgrade_policy {
    support_type = var.upgrade_support_type
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster-attachment-policy,
  ]
}


resource "aws_iam_role" "eks-cluster-role" {
  name = var.eks-cluster-role-name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster-attachment-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}


resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node-group-name
  node_role_arn   = aws_iam_role.eks-node-group-role.arn
  subnet_ids = [
    var.private-subnet-1-id,
    var.private-subnet-2-id
  ]

  scaling_config {
    desired_size = var.desired-size
    max_size     = var.max-size
    min_size     = var.min-size
  }

  disk_size      = var.instance-disk-size
  instance_types = var.instance-types
  capacity_type  = var.capacity-type

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "eks-node-group-role" {
  name = var.eks-node-group-role-name

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group-role.name
}