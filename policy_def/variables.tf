#mandatory variable keyss
variable "mandatory_tag_keys" {
  type        = list
  description = "List of mandatory tag keys used by policies 'addTagToRG'"
}

#definition category
variable "policy_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
}

#mgmt name
variable "mgmt_name" {
  type = string
  description = "mgmt group name"
}

#location
variable "location" {
    description = "location"
}