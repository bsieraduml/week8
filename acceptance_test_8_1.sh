#!/bin/bash

test $(curl calculator-service:8080/sum?a=1\&b=2) -eq 3
test $(curl calculator-service:8080/div?a=10\&b=2) -eq 5
test $(curl calculator-service:8080/div?a=10\&b=0) -eq 5