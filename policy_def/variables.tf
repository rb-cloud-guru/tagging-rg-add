#mandatory variable keyss
variable "mandatory_tag_keys" {
  type        = list(any)
  description = "List of mandatory tag keys used by policies 'addTagToRG'"
}

#tag value required
variable "mandatory_tag_value" {
  type        = string
  description = "Tag value to include with the mandatory tag keys used by policies 'addTagToRG'"
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

#assignment name
variable "pol_assignment_name" {
    description = "Policy Assignment Name"
    type = string
}

#location
variable "location" {
    description = "location"
}