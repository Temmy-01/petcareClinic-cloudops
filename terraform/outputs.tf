# terraform/aws/outputs.tf

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "ecr_registry_url" {
  description = "ECR registry base URL"
  value       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN — paste this into helm/values-production.yaml under api-gateway.service.acmCertificateArn"
  value       = aws_acm_certificate.main.arn
}

output "acm_dns_validation_records" {
  description = "Add these CNAME records to your Azure DNS zone to validate the certificate"
  value = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      cname_name  = dvo.resource_record_name
      cname_value = dvo.resource_record_value
    }
  }
}
