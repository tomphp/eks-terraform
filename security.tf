resource "aws_security_group" "eks-cluster" {
  name        = "${var.cluster-name}"
  description = "K8s training cluster (Tom Oram)"
  vpc_id      = "${aws_vpc.eks-cluster.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster-name}"
  }
}

resource "aws_security_group" "eks-cluster-node" {
  name        = "eks-${var.cluster-name}-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.eks-cluster.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "eks-${var.cluster-name}-node",
     "kubernetes.io/cluster/${var.cluster-name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "eks-cluster-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks-cluster-node.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

# Cluster connect to node
resource "aws_security_group_rule" "eks-cluster-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-cluster-node.id}"
  source_security_group_id = "${aws_security_group.eks-cluster.id}"
  to_port                  = 65535
  type                     = "ingress"
}

# Nodes connect to cluster
resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-cluster.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-node.id}"
  to_port                  = 443
  type                     = "ingress"
}

# Local office
resource "aws_security_group_rule" "local-office" {
  cidr_blocks       = ["${var.local-office}"]
  description       = "Access from the local office"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eks-cluster.id}"
  type              = "ingress"
}
