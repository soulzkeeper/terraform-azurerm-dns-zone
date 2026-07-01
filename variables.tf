variable "name" {
  description = "(Required) The name of the DNS Zone (e.g. example.com). Must be a valid domain name. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the DNS Zone. Changing this forces a new resource to be created."
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the DNS Zone."
  type        = map(string)
  default     = {}
}

variable "soa_record" {
  description = "(Optional) An SOA record block to override defaults. email is required. host_name is computed by Azure and cannot be set for public zones."
  type = object({
    email         = string
    expire_time   = optional(number, 2419200)
    minimum_ttl   = optional(number, 300)
    refresh_time  = optional(number, 3600)
    retry_time    = optional(number, 300)
    serial_number = optional(number, 1)
    ttl           = optional(number, 3600)
    tags          = optional(map(string), {})
  })
  default = null
}

variable "a_records" {
  description = "(Optional) A list of A records. Provide either records (list of IPv4 addresses) or target_resource_id for an alias record — not both."
  type = list(object({
    name               = string
    ttl                = optional(number, 3600)
    records            = optional(list(string))
    target_resource_id = optional(string)
    tags               = optional(map(string), {})
  }))
  default = []
}

variable "aaaa_records" {
  description = "(Optional) A list of AAAA records. Provide either records (list of IPv6 addresses) or target_resource_id for an alias record — not both."
  type = list(object({
    name               = string
    ttl                = optional(number, 3600)
    records            = optional(list(string))
    target_resource_id = optional(string)
    tags               = optional(map(string), {})
  }))
  default = []
}

variable "cname_records" {
  description = "(Optional) A list of CNAME records. Provide either record (a single target hostname) or target_resource_id for an alias record — not both."
  type = list(object({
    name               = string
    ttl                = optional(number, 3600)
    record             = optional(string)
    target_resource_id = optional(string)
    tags               = optional(map(string), {})
  }))
  default = []
}

variable "mx_records" {
  description = "(Optional) A list of MX records. Use name = \"@\" or \"\" for the zone apex."
  type = list(object({
    name = string
    ttl  = optional(number, 3600)
    records = list(object({
      preference = number
      exchange   = string
    }))
    tags = optional(map(string), {})
  }))
  default = []
}

variable "txt_records" {
  description = "(Optional) A list of TXT records. Each record entry is a single string value; multiple values create multiple TXT strings under the same name."
  type = list(object({
    name = string
    ttl  = optional(number, 3600)
    records = list(object({
      value = string
    }))
    tags = optional(map(string), {})
  }))
  default = []
}

variable "ns_records" {
  description = "(Optional) A list of NS records used for delegating sub-domains. records is a list of name server hostnames."
  type = list(object({
    name    = string
    ttl     = optional(number, 3600)
    records = list(string)
    tags    = optional(map(string), {})
  }))
  default = []
}

variable "ptr_records" {
  description = "(Optional) A list of PTR records. records is a list of target domain names."
  type = list(object({
    name    = string
    ttl     = optional(number, 3600)
    records = list(string)
    tags    = optional(map(string), {})
  }))
  default = []
}

variable "srv_records" {
  description = "(Optional) A list of SRV records."
  type = list(object({
    name = string
    ttl  = optional(number, 3600)
    records = list(object({
      priority = number
      weight   = number
      port     = number
      target   = string
    }))
    tags = optional(map(string), {})
  }))
  default = []
}

variable "caa_records" {
  description = "(Optional) A list of CAA records controlling which CAs may issue certificates for the domain. tag must be one of issue, issuewild, or iodef."
  type = list(object({
    name = string
    ttl  = optional(number, 3600)
    records = list(object({
      flags = number
      tag   = string
      value = string
    }))
    tags = optional(map(string), {})
  }))
  default = []
}
