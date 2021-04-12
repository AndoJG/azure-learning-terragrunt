package test

import (
	"azure_terragrunt_examples_test/helpers"
	"github.com/gruntwork-io/terratest/modules/azure"
	"net"
	"testing"
)

func TestVirtualNetwork(t *testing.T, resourceGroupName string, vnetName string, subnets map[string]helpers.Subnet, subscriptionID string) {
	checkVnetExists(t, vnetName, resourceGroupName, subscriptionID)

	for subnetName, details := range subnets {
		checkSubnetExists(t, subnetName, vnetName, resourceGroupName, subscriptionID)
		checkIPExists(t, subnetName, details.Prefix, vnetName, resourceGroupName, subscriptionID)
	}
}

func checkVnetExists(t *testing.T, vnetName string, resourceGroupName string, subscriptionID string) {
	result := azure.VirtualNetworkExists(t, vnetName, resourceGroupName, subscriptionID)
	if !result {
		t.Errorf("Virtual Network %s does not exist in resource group %s", vnetName, resourceGroupName)
	}
}

func checkSubnetExists(t *testing.T, subnetName string, vnetName string, resourceGroupName string, subscriptionID string) {
	result := azure.SubnetExists(t, subnetName, vnetName, resourceGroupName, subscriptionID)
	if !result {
		t.Errorf("Subnet %s does not exist in VNet %s", subnetName, vnetName)
	}
}

func checkIPExists(t *testing.T, subnetName string, prefix string, vnetName, resourceGroupName, subscriptionID string) {
	addr, _, _ := net.ParseCIDR(prefix)
	IP := addr.String()
	result := azure.CheckSubnetContainsIP(t, IP, subnetName, vnetName, resourceGroupName, subscriptionID)
	if !result {
		t.Errorf("IP Address %s is not contained by %s in vnet %s, but it was expected to be", IP, subnetName, vnetName)
	}
}
