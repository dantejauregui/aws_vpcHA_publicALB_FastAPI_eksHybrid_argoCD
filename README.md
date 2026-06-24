# ALB + fastApi + EKS Hybrid(EC2 + Fargate) + RDS + Grafana + openTelemetry


Use this to add the kubeconfig to your local laptop:
```
aws eks update-kubeconfig \
  --region eu-central-1 \
  --name fastApi-dev-eks \
  --profile infra-dev-admin
```

Then:
```
kubectl get nodes
```