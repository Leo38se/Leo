data "azurerm_resource_group" "example" {
  name = "maxence_rg"
}

output "id" {
  value = data.azurerm_resource_group.example.id
}

resource "azurerm_resource_group" "rg" {
  name     = "common_website_rg"
  location = "West Europe"
}


resource "azurerm_storage_account" "static_site" {
  name                     = "maxencestaticsite"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "error.html"
  }
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.static_site.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "index.html"
  content_type           = "text/html"
}


resource "azurerm_storage_blob" "error" {
  name                   = "error.html"
  storage_account_name   = azurerm_storage_account.static_site.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "error.html"
  content_type           = "text/html"
}


output "static_website_url" {
  value = azurerm_storage_account.static_site.primary_web_endpoint
}
