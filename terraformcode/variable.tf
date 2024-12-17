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
  

variable "admins_workspace" {
  type    = string
  default = "workspace_admin"
}

variable "developer_workspace" {
  type    = string
  default = "workspace_developer"
}

variable "operation_workspace" {
  type    = string
  default = "workspace_operations"
}


# Define teams and their members with access levels
variable "teams" {
  description = "A list of teams with their members and roles"
  type =list(object({
    name        = string
    description = string
    members     = list(string)
    access      = string # Possible values: admin, write, read
    org_role= string #possible values: owner, member
  }))
  default = [
    {
      name        = "executive staff"
      description = "Executive team with full permissions"
      members     = ["user1"]
      access      = "admin"
      org_role = "owner"
    },
    {
      name        = "directors"
      description = "Director team with full permissions"
      members     = ["user2"]
      access      = "admin"
      org_role = "owner"
    },
    {
      name        = "admins"
      description = "admin team"
      members     = ["user3"]
      access      = "admin"
      org_role = "member"
    },
    {
      name        = "operations"
      description = "operations team with restricted permissions"
      members     = ["user4"]
      access      = "admin"
      org_role = "member"
    },
    {
      name        = "project management"
      description = "DevOps engineer team with limited permissions"
      members     = ["user5"]
      access      = "read"
      org_role = "member"
    }
  ]
}
