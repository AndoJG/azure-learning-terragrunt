package test

import (
	"azure_terragrunt_examples_test/helpers"
	"azure_terragrunt_examples_test/test"
	"fmt"
	"os"
	"testing"
)

func TestDevInfrastructure(t *testing.T) {
	subscriptionID := ""
	currentDir, _ := os.Getwd()
	configLoc := "/config/dev.yaml"
	config, err := helpers.CreateTestConfig(currentDir + configLoc)
	if err != nil {
		fmt.Println(err)
	}
	resourceGroupName := config.Azure.Resource_group.Name
	vnetName := config.Azure.Vnet.Name
	subnets := config.Azure.Vnet.Subnets
	webapps := config.Azure.Web

	test.TestResourceGroup(t, resourceGroupName, subscriptionID)
	test.TestVirtualNetwork(t, resourceGroupName, vnetName, subnets, subscriptionID)
	test.TestWebURL(t, webapps)
}
