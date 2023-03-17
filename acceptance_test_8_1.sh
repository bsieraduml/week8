#!/bin/bash

test $(curl calculator-service:8080/sum?a=1\&b=2) -eq 3