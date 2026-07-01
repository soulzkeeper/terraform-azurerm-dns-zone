# Introduction
This Terraform module deploys an Azure public DNS Zone and manages its record sets. Azure DNS hosts your domain and provides name resolution using Microsoft's global DNS infrastructure, letting you manage records with the same credentials, APIs, and tooling as the rest of your Azure estate.

The module creates the zone (with optional SOA overrides) and, optionally, A, AAAA, CNAME, MX, TXT, NS, PTR, SRV, and CAA record sets driven by list variables.

# Getting Started
To use this module, include it in your Terraform configuration:

# Example Usage

```terraform
module "dns_zone" {
  source = "git::https://dev.azure.com/#{ADO_org}/#{ADO_project}/_git/az-tf-dns-zone"

  name                = "example.com"
  resource_group_name = "example-rg"

  soa_record = {
    email = "hostmaster.example.com"
  }

  a_records = [
    {
      name    = "www"
      ttl     = 3600
      records = ["20.10.10.1"]
    },
    {
      name               = "@"
      ttl                = 60
      target_resource_id = "<public-ip-or-frontdoor-id>" # alias record
    }
  ]

  cname_records = [
    {
      name   = "docs"
      ttl    = 3600
      record = "example.github.io"
    }
  ]

  mx_records = [
    {
      name = "@"
      ttl  = 3600
      records = [
        { preference = 10, exchange = "mail1.example.com" },
        { preference = 20, exchange = "mail2.example.com" }
      ]
    }
  ]

  txt_records = [
    {
      name = "@"
      ttl  = 3600
      records = [
        { value = "v=spf1 include:_spf.example.com -all" }
      ]
    }
  ]

  caa_records = [
    {
      name = "@"
      ttl  = 3600
      records = [
        { flags = 0, tag = "issue", value = "digicert.com" },
        { flags = 0, tag = "iodef", value = "mailto:security@example.com" }
      ]
    }
  ]

  tags = {
    Environment   = "Development"
    TerraformRepo = "<repo-name>"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | The DNS Zone name (domain) | `string` | n/a | yes |
| resource_group_name | The resource group name | `string` | n/a | yes |
| soa_record | SOA overrides (email required) | `object` | `null` | no |
| a_records | A records (records or target_resource_id alias) | `list(object)` | `[]` | no |
| aaaa_records | AAAA records (records or target_resource_id alias) | `list(object)` | `[]` | no |
| cname_records | CNAME records (record or target_resource_id alias) | `list(object)` | `[]` | no |
| mx_records | MX records (preference + exchange) | `list(object)` | `[]` | no |
| txt_records | TXT records (value strings) | `list(object)` | `[]` | no |
| ns_records | NS records for sub-domain delegation | `list(object)` | `[]` | no |
| ptr_records | PTR records | `list(object)` | `[]` | no |
| srv_records | SRV records (priority, weight, port, target) | `list(object)` | `[]` | no |
| caa_records | CAA records (flags, tag, value) | `list(object)` | `[]` | no |
| tags | Tags applied to the zone | `map(string)` | `{}` | no |

Every record object supports a `name` (use `@` or `""` for the zone apex), a `ttl` (defaults to 3600), and optional per-record `tags`.

## Outputs

| Name | Description |
|------|-------------|
| id | The DNS Zone resource ID |
| name | The DNS Zone name |
| name_servers | Azure name servers — set these as the NS delegation at your registrar |
| max_number_of_record_sets | Max record sets allowed in the zone |
| number_of_record_sets | Current record set count |
| a_record_fqdns | Map of A record names to FQDNs |
| cname_record_fqdns | Map of CNAME record names to FQDNs |
| txt_record_fqdns | Map of TXT record names to FQDNs |

## Notes

- **Delegation**: After creating the zone, point your registrar's NS records at the values in the `name_servers` output, or the zone won't resolve publicly.
- **Alias records**: For A/AAAA supply either `records` or `target_resource_id` (alias to an Azure resource such as a Public IP, Traffic Manager, or Front Door). For CNAME the equivalent field is `record` vs `target_resource_id`. Setting both on the same record conflicts.
- **Zone apex**: Use `name = "@"` (or an empty string) for apex records. CNAME is not allowed at the apex — use an A alias record instead.
- **SOA host_name**: For public zones the SOA `host_name` is assigned by Azure and is read-only, so it is intentionally not exposed as an input.
- **CAA tags**: The `tag` field must be `issue`, `issuewild`, or `iodef`. Useful for restricting which CAs can issue certs for the domain (e.g. locking to DigiCert or Let's Encrypt).
