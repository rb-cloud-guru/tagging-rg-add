#features
provider "azurerm" {
    features {}
}

#management group
data "azurerm_management_group" "mgmt_grp" {
  display_name = var.mgmt_name
}

resource "azurerm_policy_definition" "addTagToRG" {
  count = length(var.mandatory_tag_keys)

  name         = "addTagToRG_${var.mandatory_tag_keys[count.index]}"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Add tag ${var.mandatory_tag_keys[count.index]} to resource group"
  description  = "Adds the mandatory tag key ${var.mandatory_tag_keys[count.index]} when any resource group missing this tag is created or updated. \nExisting resource groups can be remediated by triggering a remediation task.\nIf the tag exists with a different value it will not be changed."

  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Resources/subscriptions/resourceGroups"
          },
          {
            "field" : "[concat('tags[', parameters('tagName'), ']')]",
            "exists" : "false"
          }
        ]
      },
      "then" : {
        "effect" : "modify",
        "details" : {
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "operations" : [
            {
              "operation" : "add",
              "field" : "[concat('tags[', parameters('tagName'), ']')]",
              "value" : "[parameters('tagValue')]"
            }
          ]
        }
      }
    }
  )
  parameters = jsonencode(
    {
      "tagName" : {
        "type" : "String",
        "metadata" : {
          "displayName" : "Mandatory Tag ${var.mandatory_tag_keys[count.index]}",
          "description" : "Name of the tag, such as ${var.mandatory_tag_keys[count.index]}"
        },
        "defaultValue" : "${var.mandatory_tag_keys[count.index]}"
      },
      "tagValue" : {
        "type" : "String",
        "metadata" : {
          "displayName" : "Tag Value '${var.mandatory_tag_value}'",
          "description" : "Value of the tag, such as '${var.mandatory_tag_value}'"
        },
        "defaultValue" : "'${var.mandatory_tag_value}'"
      }
    }
  )
}


#management group policy assignment
resource "azurerm_management_group_policy_assignment" "tag_mgmt" {
  count = length(var.pol_assignment_name)
  name                 = var.pol_assignment_name
  policy_definition_id = azurerm_policy_definition.addTagToRG[count.index].id
  management_group_id  = data.azurerm_management_group.mgmt_grp.id
  description = "Assignment of the Tag Governance initiative to Management Group."
  location = var.location
  identity { type = "SystemAssigned" }
  display_name = "Tag Governance v2"
}