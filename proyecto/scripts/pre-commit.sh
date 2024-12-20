#!/bin/bash
terraform fmt -check
python -m pylint scripts/*.py
yamllint config/*.yaml 