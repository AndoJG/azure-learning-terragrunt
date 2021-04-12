package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
)

func TestResourceGroup(t *testing.T, resourceGroupName string, subscriptionID string) {
	result := azure.ResourceGroupExists(t, resourceGroupName, subscriptionID)
	if !result {
		t.Errorf("Resource group %s does not exist", resourceGroupName)
	}
}
