provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "ODL-azure-933507"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "my-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "sec-group" {
  name                = "example-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "sec-ass" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.sec-group.id
}


# Define the AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "my-aks-cluster"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "my-aks-cluster-dns"

  # Define the Kubernetes version
  kubernetes_version = "1.25.6"

  identity {
    type = "SystemAssigned"
  }

  # Define the node pool(s)
  default_node_pool {
    name            = "default"
    vm_size         = "Standard_B2s"
    node_count      = 2
    #type            = "VirtualMachineScaleSets"
    #availability_zones = None #["1","2","3"]

    # Define the Kubernetes labels and taints
    tags = {
    Environment = "Production"
    }
    #node_taints {
    #  key    = "special"
    #  value  = "true"
    #  effect = "NoSchedule"
    #}

    # Define the network configuration
    vnet_subnet_id = azurerm_subnet.subnet.id
    #pod_cidr       = "10.244.0.0/16"
    #service_cidr   = "10.0.1.0/24"
  }

  # Enable network policy
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr = "10.0.2.0/24"
    dns_service_ip = "10.0.2.10"
  }

  # Enable RBAC authorization
  role_based_access_control_enabled = true

  # Define the service principal
  #service_principal {
  #  client_id     = "YOUR_AZURE_CLIENT_ID"
  #  client_secret = "YOUR_AZURE_CLIENT_SECRET"
  #}

  # Define the Kubernetes dashboard
  #addon_profile {
  #  kube_dashboard {
  #    enabled = true
  #  }
  #}

  # Define the auto-scaling profile
  #auto_scaler_profile {
  #  balance_simultaneous_reject_scale_down = true

    # Define the metrics
  #  metrics {
  #    name     = "cpu"
  #    type     = "Resource"
  #    target   = 70
  #    cooldown = "5m"
  #  }
  #  metrics {
  #    name     = "memory"
  #    type     = "Resource"
  #    target   = 70
  #    cooldown = "5m"
  #  }
  #  metrics {
  #    name     = "pods"
  #    type     = "Pod"
  #    target   = 10
  #    cooldown = "5m"
  #  }
  #}
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw

  sensitive = true
}