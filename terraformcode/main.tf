# Define the organization
resource "tfe_organization" "org"{
 name = var.organization_name
 email = var.organization_email
}
# Create workspaces dynamically
resource "tfe_workspace" "workspace" {
  for_each = toset(var.workspace_names)

  name         = each.key
  organization = tfe_organization.org.id
}
# Create teams dynamically based on the "teams" variable
resource "tfe_team" "team" {
for_each = {for team in var.teams : team.name => team }
  organization = tfe_organization.org.id
  name         = each.key
  }
  
#Create teams  member dynamically
resource "tfe_team_member" "team_membership" {
  for_each = {
    for team in var.teams : 
    team.name => {
      for member in team.members : 
      member => { 
        team_name = team.name
        username  = member
        org_role=team.org_role
      }
    }
  }
team_id  = tfe_team.team[each.value.team_name].id
  username = each.value.username
}
# Assign Organization Roles dynamically (owner, member)
resource "tfe_team_organization_membership" "org_roles" {
  for_each = {
    for team in var.teams : team.name => team
  }
  team_id                    = tfe_team.team[each.key].id
  organization_membership_ids = [
    for member in each.value.members : 
    tfe_organization_membership.org_members[member].id
  ]
  # Directly assign the role (owner or member) to each member
  dynamic "role" {
    for_each = each.value.org_role == "owner" ? ["owner"] : ["member"]
    content {
      role = role.value
    }
  }
}
#Create team access dynamically for each workspace ()
resource "tfe_team_access" "team_access" {
  for_each = { for team in var.teams : team.name => team }
  team_id = tfe_team.team[each.key].id # Workspace level access role (read,write, admin)
  access  = each.value.access
  # Dynamic block to grant workspace access based on team name
  dynamic "workspace" {
    for_each=(each.key=="executive staff" ||each.key=="directors") ? var.workspace_names:[]
  }
    workspace_id=tfe_workspace.workspace[workspace.value].id

    # Grant read access to all workspaces for "project management" team
  dynamic "workspace" {
    for_each = (each.key == "project management") ? var.workspace_names : []
    content {
      workspace_id = tfe_workspace.workspace[workspace.value].id
    }
  }
      
    # Grant specific workspace for other teams (Admin, Developer, Opearation,)
  dynamic "workspace" {
  for_each = (each.key == "admins") ? [var.admins_workspace] :(each.key == "developer") ? [var.developer_workspace] :(each.key == "operation") ? [var.operation_workspace] :[]
  content {
    workspace_id = tfe_workspace.workspace[workspace.value].id
  }
}
}

