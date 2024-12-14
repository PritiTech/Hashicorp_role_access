# Define the Terraform Cloud API token
variable "tfe_api_token" {
  description = "The API token for Terraform Cloud"
  type        = string
}

# Define the Terraform Cloud organization name
variable "organization_name" {
  description = "The name of the Terraform Cloud organization"
  type        = string
}

variable "organization_email" {
description = "The email for the Terraform Cloud organization"
type = string
}

# Define the workspace names where teams will have access
variable "workspace_names" {
  description = "List of workspace names"
  type        = list(string)
  
}

variable "platform_admin_workspace" {
  type    = string
  default = "workspace_platform_admin"
}

variable "salesforce_developer_workspace" {
  type    = string
  default = "workspace_salesforce"
}

variable "devops_engineer_workspace" {
  type    = string
  default = "workspace_devops"
}


# Define teams and their members with access levels
variable "teams" {
  description = "A list of teams with their members and roles"
  type =list(object({
    name        = string
    description = string
    members     = list(string)
    access      = string # Possible values: admin, write, read
  }))
  default = [
    {
      name        = "executive"
      description = "Executive team with full permissions"
      members     = ["user1"]
      access      = "admin"
    },
    {
      name        = "director"
      description = "Director team with full permissions"
      members     = ["user2"]
      access      = "admin"
    },
    {
      name        = "platform_admin"
      description = "Platform admin team"
      members     = ["user3"]
      access      = "write"
    },
    {
      name        = "salesforce_developer"
      description = "Salesforce developer team with restricted permissions"
      members     = ["user4"]
      access      = "write"
    },
    {
      name        = "devops_engineer"
      description = "DevOps engineer team with limited permissions"
      members     = ["user5"]
      access      = "write"
    }
  ]
}
