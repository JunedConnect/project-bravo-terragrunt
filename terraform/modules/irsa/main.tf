data "tls_certificate" "eks" {
  url = var.oidc-issuer-url
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = var.oidc-issuer-url
}


#cert manager:

resource "aws_iam_role" "cert-manager-irsa-role" {
  name = "cert-manager-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${aws_iam_openid_connect_provider.eks.url}:sub" = "system:serviceaccount:${var.cert-manager-namespace}:cert-manager"
          "${aws_iam_openid_connect_provider.eks.url}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "cert-manager-irsa-policy" {
  name = "cert-manager-irsa-policy"
  role = aws_iam_role.cert-manager-irsa-role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "route53:GetChange",
        "Effect" : "Allow",
        "Resource" : "arn:aws:route53:::change/*"
      },
      {
        "Action" : [
          "route53:ListResourceRecordSets",
          "route53:ChangeResourceRecordSets"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:route53:::hostedzone/${var.route53-zone-id}"
      },
      {
        "Action" : "route53:ListHostedZonesByName",
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}


# #externaldns

resource "aws_iam_role" "external-dns-irsa-role" {
  name = "external-dns-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${aws_iam_openid_connect_provider.eks.url}:sub" = "system:serviceaccount:${var.external-dns-namespace}:external-dns"
          "${aws_iam_openid_connect_provider.eks.url}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}


resource "aws_iam_role_policy" "external-dns-irsa-policy" {
  name = "external-dns-irsa-policy"
  role = aws_iam_role.external-dns-irsa-role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "route53:ChangeResourceRecordSets",
        "Effect" : "Allow",
        "Resource" : "arn:aws:route53:::hostedzone/${var.route53-zone-id}"
      },
      {
        "Action" : [
          "route53:ListTagsForResource",
          "route53:ListResourceRecordSets",
          "route53:ListHostedZones"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}