#!/bin/bash

pip install -r requirements.txt

echo "Container is running"

exec "$@"