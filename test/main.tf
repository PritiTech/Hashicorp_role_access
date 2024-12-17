# Define the organization
resource "tfe_organization" "org"{
 name = var.organization_name
 email = var.organization_email
}

# Create teams dynamically based on the "teams" variable
resource "tfe_team" "team" {
for_each = {for team in var.teams : team.name => team }
  organization = tfe_organization.org.name
  name         = each.key
  }

#Create teams  member dynamically
resource "tfe_team_membership" "team_membership" {
  for_each = {
    for team in var.teams : 
    team.name => {
      for member in team.members : 
      member => { 
        team_name = team.name
        username  = member
      }
    }
  }
team_id  = tfe_team.team[each.value.team_name].id
  username = each.value.username
}

#Create team access dynamically for each workspace
resource "tfe_team_access" "team_access" {
  for_each = { for team in var.teams : team.name => team }

  team_id = tfe_team.team[each.key].id
  access  = each.value.access
  dynamic "workspace" {
    for_each=(each.key=="executive" ||each.key=="director") ? var.workspace_names:[]
  }
    workspace_id=workspace.value
    
  
        
    # Grant specific workspace for other teams (Platform Admin, Salesforce Developer, DevOps Engineer)
  dynamic "workspace" {
  for_each = (each.key == "platform_admin") ? [var.platform_admin_workspace] :(each.key == "salesforce_developer") ? [var.salesforce_developer_workspace] :(each.key == "devops_engineer") ? [var.devops_engineer_workspace] :[]
  content {
    workspace_id = workspace.value
  }
}
}
    # Assign Organization Admin Role to Executive and Director Teams
resource "tfe_organization_team_membership" "org_admin_membership" {
  for_each = {
    for team in var.teams :
    team.name => team if team.name == "executive" || team.name == "director"
  }

  organization = tfe_organization.org.name
  team_id      = tfe_team.team[each.key].id
  role         = "admin"  # Grant organization admin access
}
  



