variable "metro_code" {
  description = "Device location metro code"
  type        = string
  validation {
    condition     = can(regex("^[A-Z]{2}$", var.metro_code))
    error_message = "Valid metro code consists of two capital letters, i.e. SV, DC."
  }
}

variable "project_id" {
  description = "project_id"
  type        = string
}

variable "account_number" {
  description = "Billing account number for a device"
  type        = string
  default     = 0
}

variable "platform" {
  description = "Device platform flavor that determines number of CPU cores and memory"
  type        = string
  validation {
    condition     = can(regex("^(small|medium|large)$", var.platform))
    error_message = "One of following platform flavors are supported: small, medium, large."
  }
}

variable "software_package" {
  description = "Device software package"
  type        = string
  validation {
    condition     = can(regex("^(VM100|VM300|VM500)$", var.software_package))
    error_message = "One of following software packages are supported: STD."
  }
}

variable "name" {
  description = "Device name"
  type        = string
  validation {
    condition     = length(var.name) >= 2 && length(var.name) <= 50
    error_message = "Device name should consist of 2 to 50 characters."
  }
}

variable "hostname" {
  description = "Device hostname"
  type        = string
  default     = ""
}

variable "term_length" {
  description = "Term length in months"
  type        = number
  validation {
    condition     = can(regex("^(1|12|24|36)$", var.term_length))
    error_message = "One of following term lengths are available: 1, 12, 24, 36 months."
  }
}

variable "notifications" {
  description = "List of email addresses that will receive device status notifications"
  type        = list(string)
  validation {
    condition     = length(var.notifications) > 0
    error_message = "Notification list cannot be empty."
  }
}

variable "acl_template_id" {
  description = "Identifier of an management ACL template that will be applied on a device"
  type        = string
  default     = ""
}

variable "mgmt_acl_template_uuid" {
  description = "Identifier of an management ACL template that will be applied on a device"
  type        = string
  default     = ""
}

variable "connectivity" {
  description = "Parameter to identify internet access for device. Supported Values: INTERNET-ACCESS(default) or PRIVATE or INTERNET-ACCESS-WITH-PRVT-MGMT"
  type        = string
  default     = "INTERNET-ACCESS"
}

variable "additional_bandwidth" {
  description = "Additional internet bandwidth for a device"
  type        = number
  default     = 0
  validation {
    condition     = var.additional_bandwidth == 0 || (var.additional_bandwidth >= 25 && var.additional_bandwidth <= 2001)
    error_message = "Additional internet bandwidth should be between 25 and 2001 Mbps."
  }
}
variable "ssh_key" {
  description = "SSH public key for a device"
  type = object({
    userName = string
    keyName  = string
  })
}

variable "interface_count" {
  description = "Number of network interfaces on a device. If not specified, default number for a given device type will be used."
  type        = number
  default     = 10
}

variable "secondary" {
  description = "Secondary device attributes"
  type        = map(any)
  default     = { enabled = false }
  validation {
    condition     = can(var.secondary.enabled)
    error_message = "Key 'enabled' has to be defined for secondary device."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || can(regex("^[A-Z]{2}$", var.secondary.metro_code))
    error_message = "Key 'metro_code' has to be defined for secondary device. Valid metro code consits of two capital leters, i.e. SV, DC."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || try(length(var.secondary.hostname) >= 2 && length(var.secondary.hostname) <= 10, false)
    error_message = "Key 'hostname' has to be defined for secondary device. Valid hostname has to be from 2 to 10 characters long."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || try(var.secondary.additional_bandwidth >= 25 && var.secondary.additional_bandwidth <= 2001, true)
    error_message = "Key 'additional_bandwidth' has to be between 25 and 2001 Mbps."
  }
  validation {
    condition     = !try(var.secondary.enabled, false) || try(var.secondary.acl_template_id != null, true)
    error_message = "Secondary management Acl template is required."
  }
}
variable "cluster" {
  description = "cluster device attributes"
  type        = map(any)
  default     = { enabled = false }

  validation {
    condition     = !try(var.cluster.enabled, false) || try(var.cluster.name != null, true)
    error_message = "Cluster name is required."
  }
  validation {
    condition     = can(var.cluster.enabled)
    error_message = "Key 'enabled' has to be defined for secondary device."
  }
  validation {
    condition     = !try(var.cluster.enabled, false) || try(length(var.cluster.node0_vendor_configuration_hostname) >= 2 && length(var.cluster.node0_vendor_configuration_hostname) <= 10, false)
    error_message = "Key 'node0.vendorConfig.hostname' has to be defined for cluster device. Valid hostname has to be from 2 to 10 characters long."
  }

  validation {
    condition     = !try(var.cluster.enabled, false) || try(length(var.cluster.node1_vendor_configuration_hostname) >= 2 && length(var.cluster.node1_vendor_configuration_hostname) <= 10, false)
    error_message = "Key 'node0.vendorConfig.hostname' has to be defined for cluster device. Valid hostname has to be from 2 to 10 characters long."
  }

}
