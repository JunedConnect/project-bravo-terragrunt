resource "helm_release" "cert-manager" {
  name       = var.cert-manager-helm-name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  create_namespace = true
  namespace        = var.cert-manager-namespace

  set {
    name  = "crds.enabled"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.cert-manager-irsa-role-arn # this will link the service account to the iam role
  }

  values = [
    file(var.cert-manager-helm-values-file-path)
  ]

  depends_on = [helm_release.nginx-ingress-controller]
}


resource "helm_release" "external-dns" {
  name       = var.external-dns-helm-name
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "external-dns"

  create_namespace = true
  namespace        = var.external-dns-namespace

  set {
    name  = "wait-for"
    value = var.external-dns-irsa-role-arn
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.external-dns-irsa-role-arn # this will link the service account to the iam role
  }

  values = [
    file(var.external-dns-helm-values-file-path)
  ]

  depends_on = [helm_release.nginx-ingress-controller]
}


resource "helm_release" "nginx-ingress-controller" {
  name       = var.nginx-ingress-helm-name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  create_namespace = true
  namespace        = var.nginx-ingress-namespace
}


resource "helm_release" "argocd" {
  name       = var.argocd-helm-name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  timeout    = "600"
  version    = "5.19.15"

  create_namespace = true
  namespace        = var.argocd-namespace

  values = [
    file(var.argocd-helm-values-file-path)
  ]

  depends_on = [helm_release.nginx-ingress-controller]
}


resource "helm_release" "prom-graf" {
  name       = var.prom-graf-helm-name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  create_namespace = true
  namespace        = var.prom-graf-namespace

  values = [
    file(var.prom-graf-helm-values-file-path)
  ]

  depends_on = [helm_release.nginx-ingress-controller]
}