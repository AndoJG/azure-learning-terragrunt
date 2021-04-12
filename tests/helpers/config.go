package helpers

import (
	"os"

	"gopkg.in/yaml.v2"
)

// Config struct for test env config
type Config struct {
	Azure struct {
		Resource_group struct {
			// resource group name
			Name string
		}
		Vnet struct {
			Name    string
			Subnets map[string]Subnet
		}
		Web map[string]Webapp
	}
}

type Subnet struct {
	Prefix string
}

type Webapp struct {
	Address           string
	Expected_response string
}

func CreateTestConfig(configPath string) (*Config, error) {
	config := &Config{}
	file, err := os.Open(configPath)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	// Init new YAML decoder
	d := yaml.NewDecoder(file)

	// Start YAML decoding from file
	if err := d.Decode(&config); err != nil {
		return nil, err
	}

	return config, err
}
