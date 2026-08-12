variable project_name {}
variable instance_type {}
variable root_volume_size {}
variable root_volume_type {}
variable max_size {}
variable min_size {}
variable desired_capacity {}
variable subnet_ids {
    type = list(string)
}
variable key_name {}
variable security_group_ids {}
variable target_group_arn {}
variable secrets_arn {}
variable chat_front_ecr_arn {}
variable chat_svc_ecr_arn {}
variable chat_db_ecr_arn {}
variable deployment_bucket_name {
    type = string
}