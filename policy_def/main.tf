#features
provider "azurerm" {
    features {}
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
          "operations": [
            {
              "operation": "add",
              "field": "[concat('tags[', parameters('tagName'), ']')]",
              "value": "[resourceGroup().tags[parameters('tagName')]]"
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
      }
    }
  )
}

#sub
data "azurerm_subscription" "current" {}

#management group policy assignment
resource "azurerm_subscription_policy_assignment" "tag_mgmt" {
    count = length(var.mandatory_tag_keys)
    name                 = "assign-name-${var.mandatory_tag_keys[count.index]}"
    policy_definition_id = element(azurerm_policy_definition.addTagToRG.*.id,count.index)
    subscription_id  = data.azurerm_subscription.current.id
    description = "Assignment of the Tag Governance initiative to Management Group."
    location = var.location
    identity { type = "SystemAssigned" }
    display_name = "disp-name-${var.mandatory_tag_keys[count.index]}"
    metadata = <<METADATA
    {
    "category": "General"
    }
    METADATA
    parameters = jsonencode({
    "tagName": {
    "value":  var.mandatory_tag_keys[count.index],
  }
}
  )
}