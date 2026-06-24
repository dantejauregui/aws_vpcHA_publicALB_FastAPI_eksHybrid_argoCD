output "argocd_namespace" {
  value = "argocd"
}

output "argocd_release_name" {
  value = helm_release.argocd.name
}

output "argocd_username" {

  value = "admin"
}

# After deploy, to see sensitive value use: "cd live/02-platform/2.1_argocd" and "terragrunt output -raw argocd_password"
output "argocd_password" {

  description = "Initial ArgoCD admin password"

  value = data.kubernetes_secret_v1.argocd_admin_secret.data.password

  sensitive = true
}

output "argocd_command" {

  value = "kubectl port-forward svc/argocd-server -n argocd 8080:80"
}
