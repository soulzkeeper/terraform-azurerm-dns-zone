output "id" {
  description = "The ID of the DNS Zone."
  value       = azurerm_dns_zone.dns_zone.id
}

output "name" {
  description = "The name of the DNS Zone."
  value       = azurerm_dns_zone.dns_zone.name
}

output "name_servers" {
  description = "A list of the Azure name servers for this DNS Zone. Use these to configure the NS delegation at your domain registrar."
  value       = azurerm_dns_zone.dns_zone.name_servers
}

output "max_number_of_record_sets" {
  description = "The maximum number of record sets that can be created in this DNS Zone."
  value       = azurerm_dns_zone.dns_zone.max_number_of_record_sets
}

output "number_of_record_sets" {
  description = "The current number of record sets in this DNS Zone."
  value       = azurerm_dns_zone.dns_zone.number_of_record_sets
}

output "a_record_fqdns" {
  description = "A map of A record names to their FQDNs."
  value       = { for k, v in azurerm_dns_a_record.a : k => v.fqdn }
}

output "cname_record_fqdns" {
  description = "A map of CNAME record names to their FQDNs."
  value       = { for k, v in azurerm_dns_cname_record.cname : k => v.fqdn }
}

output "txt_record_fqdns" {
  description = "A map of TXT record names to their FQDNs."
  value       = { for k, v in azurerm_dns_txt_record.txt : k => v.fqdn }
}
