package transpiler

import (
	"regexp"
)

type rxRegistry []*regexp.Regexp

func newRxRegistry(registry []string) (rxRegistry, error) {
	rxRegistry := make([]*regexp.Regexp, 0, len(registry))
	for _, entry := range registry {
		rx, err := regexp.Compile(entry)
		if err != nil {
			return nil, err
		}
		rxRegistry = append(rxRegistry, rx)
	}
	return rxRegistry, nil
}

func (reg rxRegistry) Contains(entry string) bool {
	for _, rx := range reg {
		if rx.MatchString(entry) {
			return true
		}
	}
	return false
}
