package test

import (
	"azure_terragrunt_examples_test/helpers"
	"io/ioutil"
	"net/http"
	"testing"
)

func TestWebURL(t *testing.T, webapps map[string]helpers.Webapp) {
	for _, details := range webapps {
		resp, err := http.Get(details.Address)
		if err != nil {
			print(err)
		}
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		if err != nil {
			print(err)
		}

		if resp.StatusCode != 200 {
			t.Errorf("Expected status code: 200, got: %d", resp.StatusCode)
		}

		if string(body) != details.Expected_response {
			t.Errorf("\nExpected a response body of:\n %s\nbut received:\n %s", details.Expected_response, string(body))
		}
	}
}
