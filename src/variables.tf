variable "prefix" {
  default = "demo"
}

variable "location" {
  default  = "Australia SouthEast"
}

variable "statekey" {
  description = "Access key for the container to store state."
  # for value we could have a placeholder and replace the value either from Azure DevOps variable or tie that var to Azure KV secret.
}