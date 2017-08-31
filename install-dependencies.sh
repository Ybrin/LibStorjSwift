#!/bin/bash

unknown="unknown"
pm="$unknown"
package="$unknown"

case "$OSTYPE" in
  solaris*)
  echo "SOLARIS"
  ;;
  darwin*)
  echo "OSX"
  ;;
  linux*)
  echo "LINUX"
  ;;
  bsd*)
  echo "BSD"
  ;;
  msys*)
  echo "WINDOWS"
  ;;
  *)
  echo "unknown: $OSTYPE" ;;
esac

if [ "$pm" == "$unknown" ] || [ "$package" == "$unknown" ]; then
  echo 'Sorry but we are currently only supporting macOS and Debian derivatives'
  exit 1
fi
