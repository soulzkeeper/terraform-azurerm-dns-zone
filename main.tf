resource "azurerm_dns_zone" "dns_zone" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "soa_record" {
    for_each = var.soa_record != null ? [var.soa_record] : []
    content {
      email         = soa_record.value.email
      expire_time   = soa_record.value.expire_time
      minimum_ttl   = soa_record.value.minimum_ttl
      refresh_time  = soa_record.value.refresh_time
      retry_time    = soa_record.value.retry_time
      serial_number = soa_record.value.serial_number
      ttl           = soa_record.value.ttl
      tags          = soa_record.value.tags
    }
  }
}

resource "azurerm_dns_a_record" "a" {
  for_each = { for r in var.a_records : r.name => r }

  name                = each.value.name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.target_resource_id == null ? each.value.records : null
  target_resource_id  = each.value.target_resource_id
  tags                = each.value.tags
}

resource "azurerm_dns_aaaa_record" "aaaa" {
  for_each = { for r in var.aaaa_records : r.name => r }

  name                = each.value.name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.target_resource_id == null ? each.value.records : null
  target_resource_id  = each.value.target_resource_id
  tags                = each.value.tags
}

resource "azurerm_dns_cname_record" "cname" {
  for_each = { for r in var.cname_records : r.name => r }

  name                = each.value.name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  record              = each.value.target_resource_id == null ? each.value.record : null
  target_resource_id  = each.value.target_resource_id
  tags                = each.value.tags
}

resource "azurerm_dns_mx_record" "mx" {
  for_each = { for r in var.mx_records : r.name => r }

  name                = each.value.name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  tags                = each.value.tags

  dynamic "record" {
    for_each = each.value.records
    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }
}

resource "azurerm_dns_txt_record" "txt" {
  for_each = { for r in var.txt_records : r.name => r }

  name                = each.value.name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  tags                = each.value.tags

  dynamic "record" {
    for_each = each.value.records
    content {
      value = record.value.value
    }
  }
}

resource "azurerm_dns_ns_record" "ns" {
  for_each = { for r in var.ns_records : r.name => r }

  name                = each.value.name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = each.value.tags
}

resource "azurerm_dns_ptr_record" "ptr" {
  for_each = { for r in var.ptr_records : r.name => r }

  name                = each.value.name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = each.value.tags
}

resource "azurerm_dns_srv_record" "srv" {
  for_each = { for r in var.srv_records : r.name => r }

  name                = each.value.name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  tags                = each.value.tags

  dynamic "record" {
    for_each = each.value.records
    content {
      priority = record.value.priority
      weight   = record.value.weight
      port     = record.value.port
      target   = record.value.target
    }
  }
}

resource "azurerm_dns_caa_record" "caa" {
  for_each = { for r in var.caa_records : r.name => r }

  name                = each.value.name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  tags                = each.value.tags

  dynamic "record" {
    for_each = each.value.records
    content {
      flags = record.value.flags
      tag   = record.value.tag
      value = record.value.value
    }
  }
}
